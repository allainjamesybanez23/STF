import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:save_the_fuel/data/cebu_seed_data.dart';
import 'package:save_the_fuel/data/local_db.dart';
import 'package:save_the_fuel/logic/savings_calculator.dart';
import 'package:save_the_fuel/models/fuel_station.dart';
import 'package:save_the_fuel/models/geofence.dart';

class AppState extends ChangeNotifier {
  Position? currentPosition;
  double speedKph = 0;
  ZoneType activeZoneType = ZoneType.green;
  Geofence? activeFence;
  String hudPrompt = 'SMOOTH CRUISE - SAVE FUEL';
  int redZoneSlowSeconds = 0;
  int idleSeconds = 0;
  double todayPhpSaved = 0;
  double todayLitersSaved = 0;
  final double currentEarningsPhp = 1200;
  bool isIdlingBySensor = false;
  final List<LatLng> pathTrail = [];
  FuelType selectedFuelType = FuelType.diesel;
  DateTime? _lastCheapestTipAt;
  String? lastCheapestTipStation;

  final List<FuelStation> stations = List<FuelStation>.from(hardcodedStations);
  final FlutterTts _tts = FlutterTts();

  StreamSubscription<Position>? _positionSub;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  Timer? _secondTicker;
  DateTime _lastMovement = DateTime.now();
  ZoneType? _lastSpokenZone;
  final Map<int, double> hourlyNetIncome = {
    5: 40,
    6: 55,
    7: 65,
    8: 72,
    9: 85,
    10: 98,
    11: 110,
    12: 120,
    13: 118,
    14: 108,
    15: 102,
    16: 109,
    17: 132,
    18: 148,
    19: 136,
    20: 98,
    21: 78,
  };

  Future<void> initialize() async {
    await _initTts();
    await _loadTodayStats();
    _listenSensors();
    await _startGps();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.46);
    await _tts.setVolume(1.0);
  }

  String get _dayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadTodayStats() async {
    final row = await LocalDb.instance.loadStatsForDay(_dayKey);
    idleSeconds = row['idle_seconds'] as int;
    todayPhpSaved = (row['php_saved'] as num).toDouble();
    todayLitersSaved = (row['liters_saved'] as num).toDouble();
    notifyListeners();
  }

  Future<void> _persistStats() async {
    await LocalDb.instance.upsertStats(
      dayKey: _dayKey,
      idleSeconds: idleSeconds,
      phpSaved: todayPhpSaved,
      litersSaved: todayLitersSaved,
    );
  }

  void _listenSensors() {
    _accelSub = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
      );
      final dynamicDelta = (magnitude - 9.8).abs();
      if (dynamicDelta > 0.9) {
        _lastMovement = DateTime.now();
      }
      final stillFor = DateTime.now().difference(_lastMovement);
      isIdlingBySensor = stillFor.inSeconds >= 8;
    });
  }

  Future<void> _startGps() async {
    try {
      final service = await Geolocator.isLocationServiceEnabled();
      if (!service) return;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }

      // Avoid GNSS NMEA callback path on emulators (can crash system service).
      final locationSettings = LocationSettings(
        accuracy: Platform.isAndroid ? LocationAccuracy.high : LocationAccuracy.best,
        distanceFilter: Platform.isAndroid ? 8 : 3,
      );

      _positionSub = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        _handlePosition,
        onError: (error) {
          debugPrint('Position stream error: $error');
        },
      );

      _secondTicker = Timer.periodic(const Duration(seconds: 1), (_) async {
        if (activeZoneType == ZoneType.red) {
          redZoneSlowSeconds += 1;
        } else {
          redZoneSlowSeconds = 0;
        }

        if (activeZoneType == ZoneType.red && speedKph < 1 && isIdlingBySensor) {
          idleSeconds += 1;
          todayPhpSaved = SavingsTracker.idleLossPhp(idleSeconds);
          todayLitersSaved = SavingsTracker.litersSavedFromIdle(idleSeconds);
          await _persistStats();
        }

        _refreshPrompt();
        notifyListeners();
      });
    } catch (error) {
      debugPrint('GPS init skipped: $error');
    }
  }

  void _handlePosition(Position pos) {
    currentPosition = pos;
    speedKph = pos.speed < 0 ? 0 : pos.speed * 3.6;
    final nextPoint = LatLng(pos.latitude, pos.longitude);
    if (pathTrail.isEmpty ||
        Geolocator.distanceBetween(
              pathTrail.last.latitude,
              pathTrail.last.longitude,
              nextPoint.latitude,
              nextPoint.longitude,
            ) >
            5) {
      pathTrail.add(nextPoint);
      if (pathTrail.length > 240) {
        pathTrail.removeAt(0);
      }
    }
    _resolveZone(pos);
    _checkCheapestStationProximity();
    _refreshPrompt();
    _maybeSpeak();
    notifyListeners();
  }

  void _resolveZone(Position pos) {
    Geofence? detected;
    var bestDistance = double.infinity;
    for (final fence in cebuGeofences) {
      final distance = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        fence.center.latitude,
        fence.center.longitude,
      );
      if (distance <= fence.radiusMeters && distance < bestDistance) {
        detected = fence;
        bestDistance = distance;
      }
    }
    activeFence = detected;
    if (detected != null &&
        (detected.type == ZoneType.red || detected.type == ZoneType.amber)) {
      activeZoneType = detected.type;
      return;
    }
    activeZoneType = _speedDrivenZone();
  }

  ZoneType _speedDrivenZone() {
    if (speedKph > 35) return ZoneType.red;
    if (speedKph > 20) return ZoneType.amber;
    return ZoneType.green;
  }

  FuelStation get cheapestStationForProfile {
    final sorted = List<FuelStation>.from(stations)
      ..sort(
        (a, b) => a.priceFor(selectedFuelType).compareTo(b.priceFor(selectedFuelType)),
      );
    return sorted.first;
  }

  double get cheapestPrice => cheapestStationForProfile.priceFor(selectedFuelType);

  double get profileAveragePrice {
    if (stations.isEmpty) return 0;
    final total = stations.fold<double>(
      0,
      (sum, s) => sum + s.priceFor(selectedFuelType),
    );
    return total / stations.length;
  }

  double get profileSavingsPerLiter => profileAveragePrice - cheapestPrice;

  List<double> get weeklyNetIncomeSeries {
    return const [380, 340, 470, 200, 415, 550, 410];
  }

  int get bestProfitHour {
    final best = hourlyNetIncome.entries.reduce((a, b) => a.value > b.value ? a : b);
    return best.key;
  }

  void setFuelType(FuelType type) {
    selectedFuelType = type;
    notifyListeners();
  }

  void _checkCheapestStationProximity() {
    if (currentPosition == null) return;
    final station = cheapestStationForProfile;
    final distanceMeters = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      station.location.latitude,
      station.location.longitude,
    );

    if (distanceMeters <= 500) {
      final now = DateTime.now();
      final freshEnough = _lastCheapestTipAt == null ||
          now.difference(_lastCheapestTipAt!).inMinutes >= 5 ||
          lastCheapestTipStation != station.name;
      if (freshEnough) {
        lastCheapestTipStation = station.name;
        _lastCheapestTipAt = now;
        unawaited(
          _tts.speak(
            'Tip: cheapest ${fuelTypeLabel(selectedFuelType)} nearby at ${station.brand} ${station.name}.',
          ),
        );
      }
    }
  }

  void _refreshPrompt() {
    if (activeFence?.type == ZoneType.red) {
      hudPrompt = 'TRAFFIC AHEAD - STOP / CUT ENGINE';
    } else if (activeFence?.type == ZoneType.amber) {
      hudPrompt = 'TRAFFIC LIGHT AHEAD - COAST';
    } else if (activeZoneType == ZoneType.red) {
      hudPrompt = 'TOO FAST - WASTING FUEL';
    } else if (activeZoneType == ZoneType.amber) {
      hudPrompt = 'COAST - NO ACCEL';
    } else {
      hudPrompt = 'SMOOTH CRUISE - SAVE FUEL';
    }
  }

  Future<void> _maybeSpeak() async {
    if (_lastSpokenZone == activeZoneType) return;
    _lastSpokenZone = activeZoneType;
    final line = switch (activeZoneType) {
      ZoneType.red => 'You are overspeeding and burning fuel, slow down',
      ZoneType.amber => 'Hold speed, coast and avoid hard acceleration',
      ZoneType.green => 'Great pace, smooth cruise saves fuel',
    };
    await _tts.speak(line);
  }

  void verifyStation(int index) {
    stations[index] = stations[index].copyWith(verified: true);
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _accelSub?.cancel();
    _secondTicker?.cancel();
    _tts.stop();
    super.dispose();
  }
}
