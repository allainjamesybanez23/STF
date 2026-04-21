import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../services/traffic_service.dart';
import '../services/location_service.dart';
import '../services/tts_service.dart';

class TrafficProvider extends ChangeNotifier {
  final TrafficService _trafficService = TrafficService();
  final LocationService _locationService = LocationService();
  final TtsService _ttsService = TtsService();

  String _currentZone = 'GREEN';
  Position? _currentPosition;
  bool _isLoading = true;
  StreamSubscription<Position>? _locationSubscription;
  Timer? _debounceTimer;
  bool _hasSpokenForZone = false;

  String get currentZone => _currentZone;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;

  TrafficProvider() {
    _init();
  }

  Future<void> _init() async {
    await _locationService.init();
    await _ttsService.init();
    _listenToLocation();
    _isLoading = false;
    notifyListeners();
  }

  void _listenToLocation() {
    // Only listen once, not every time positionStream is accessed
    _locationSubscription = _locationService.positionStream.listen((
      Position position,
    ) {
      _currentPosition = position;
      final newZone = _trafficService.checkZone(position);

      // Only update and speak if zone changed
      if (newZone != _currentZone) {
        _currentZone = newZone;
        _hasSpokenForZone = false; // Reset flag for new zone
        notifyListeners();

        // Speak zone status only once per zone change
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 300), () {
          if (!_hasSpokenForZone) {
            _ttsService.speakZoneStatus(_currentZone);
            _hasSpokenForZone = true;
          }
        });
      }
    });
  }

  Future<void> reportAccident() async {
    if (_currentPosition == null) return;
    try {
      print(
        'Accident reported at ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
      );
    } catch (e) {
      print('Report error: $e');
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _debounceTimer?.cancel();
    _locationService.dispose();
    super.dispose();
  }
}
