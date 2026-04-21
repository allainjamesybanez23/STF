import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../models/trip_model.dart';
import '../models/vehicle_model.dart';
import '../services/traffic_service.dart';

class TripProvider extends ChangeNotifier {
  TripModel? _currentTrip;
  late List<TripModel> _tripHistory;
  double _currentDistance = 0;
  int _redZoneTime = 0;
  int _cautionZoneTime = 0;
  StreamSubscription<Position>? _locationSubscription;
  DateTime? _lastZoneChangeTime;
  String? _lastZone;
  Position? _lastPosition;
  final TrafficService _trafficService = TrafficService();

  TripModel? get currentTrip => _currentTrip;
  List<TripModel> get tripHistory => _tripHistory;
  double get currentDistance => _currentDistance;
  int get redZoneTime => _redZoneTime;
  int get cautionZoneTime => _cautionZoneTime;

  TripProvider() {
    _loadHardcodedTripHistory();
  }

  void _loadHardcodedTripHistory() {
    // Initialize with hardcoded trip history
    _tripHistory = [
      TripModel(
        id: '1',
        vehicleType: VehicleType.traditionalJeep,
        startLat: 10.3157,
        startLng: 123.8854,
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endLat: 10.3200,
        endLng: 123.8900,
        endTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        distanceKm: 8.5,
        fuelPrice: 60,
        redZoneMinutes: 15,
        cautionZoneMinutes: 10,
      ),
      TripModel(
        id: '2',
        vehicleType: VehicleType.modernJeep,
        startLat: 10.3157,
        startLng: 123.8854,
        startTime: DateTime.now().subtract(const Duration(hours: 4)),
        endLat: 10.3100,
        endLng: 123.8750,
        endTime: DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
        distanceKm: 12.3,
        fuelPrice: 60,
        redZoneMinutes: 20,
        cautionZoneMinutes: 15,
      ),
      TripModel(
        id: '3',
        vehicleType: VehicleType.bus,
        startLat: 10.3157,
        startLng: 123.8854,
        startTime: DateTime.now().subtract(const Duration(hours: 6)),
        endLat: 10.3300,
        endLng: 123.9000,
        endTime: DateTime.now().subtract(const Duration(hours: 5, minutes: 15)),
        distanceKm: 15.7,
        fuelPrice: 60,
        redZoneMinutes: 25,
        cautionZoneMinutes: 20,
      ),
    ];
  }

  Future<void> startTrip(VehicleType vehicleType, double fuelPrice) async {
    Position pos = await Geolocator.getCurrentPosition();

    _currentTrip = TripModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      vehicleType: vehicleType,
      startLat: pos.latitude,
      startLng: pos.longitude,
      startTime: DateTime.now(),
      distanceKm: 0,
      fuelPrice: fuelPrice,
    );

    _currentDistance = 0;
    _redZoneTime = 0;
    _cautionZoneTime = 0;
    _lastZone = _trafficService.checkZone(pos);
    _lastZoneChangeTime = DateTime.now();
    _lastPosition = pos;

    // Start listening to location updates
    _startLocationTracking();

    notifyListeners();
  }

  void _startLocationTracking() {
    // Cancel any existing subscription
    _locationSubscription?.cancel();

    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5, // Update every 5 meters
          ),
        ).listen((Position position) {
          _updateTripLocation(position);
        });
  }

  void _updateTripLocation(Position position) {
    if (_currentTrip == null || _lastPosition == null) return;

    // Calculate distance traveled from last position
    double distanceTraveled = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    // Convert meters to kilometers and add to total
    _currentDistance += distanceTraveled / 1000;

    // Check current zone
    String newZone = _trafficService.checkZone(position);

    // Track zone change and time spent
    if (newZone != _lastZone) {
      if (_lastZoneChangeTime != null) {
        int elapsedSeconds = DateTime.now()
            .difference(_lastZoneChangeTime!)
            .inSeconds;

        if (_lastZone == 'RED') {
          _redZoneTime += elapsedSeconds;
        } else if (_lastZone == 'CAUTION') {
          _cautionZoneTime += elapsedSeconds;
        }
      }

      _lastZone = newZone;
      _lastZoneChangeTime = DateTime.now();

      print(
        'Zone changed to: $newZone at ${_currentDistance.toStringAsFixed(2)} km',
      );
    }

    _lastPosition = position;
    notifyListeners();
  }

  Future<void> endTrip() async {
    if (_currentTrip == null) return;

    // Stop listening to location updates
    _locationSubscription?.cancel();

    // Add final zone time
    if (_lastZoneChangeTime != null) {
      int elapsedSeconds = DateTime.now()
          .difference(_lastZoneChangeTime!)
          .inSeconds;

      if (_lastZone == 'RED') {
        _redZoneTime += elapsedSeconds;
      } else if (_lastZone == 'CAUTION') {
        _cautionZoneTime += elapsedSeconds;
      }
    }

    Position pos = await Geolocator.getCurrentPosition();

    // Create final trip record
    final completedTrip = TripModel(
      id: _currentTrip!.id,
      vehicleType: _currentTrip!.vehicleType,
      startLat: _currentTrip!.startLat,
      startLng: _currentTrip!.startLng,
      startTime: _currentTrip!.startTime,
      endLat: pos.latitude,
      endLng: pos.longitude,
      endTime: DateTime.now(),
      distanceKm: _currentDistance,
      fuelPrice: _currentTrip!.fuelPrice,
      redZoneMinutes: _redZoneTime ~/ 60,
      cautionZoneMinutes: _cautionZoneTime ~/ 60,
    );

    // Save to local history
    print(
      'Trip saved: ${completedTrip.id} | Distance: ${_currentDistance.toStringAsFixed(2)} km',
    );

    _tripHistory.insert(0, completedTrip);
    _currentTrip = null;
    _currentDistance = 0;
    _lastPosition = null;

    notifyListeners();
  }

  // Get current trip duration in minutes (for active trips)
  int getCurrentTripDurationMinutes() {
    if (_currentTrip == null) return 0;
    return DateTime.now().difference(_currentTrip!.startTime).inMinutes;
  }

  // Get total fuel saved across all trips
  double getTotalFuelSaved() {
    return _tripHistory.fold(0, (sum, trip) => sum + trip.netSavings);
  }

  // Get total money saved across all trips
  double getTotalMoneySaved() {
    return _tripHistory.fold(0, (sum, trip) => sum + trip.idlingSavings);
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
