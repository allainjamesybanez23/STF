import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamController<Position>? _positionController;
  Stream<Position>? _positionStream;
  StreamSubscription<Position>? _geolocatorSubscription;
  bool _isListening = false;

  Future<void> init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }

    _positionController = StreamController<Position>.broadcast();
    _positionStream = _positionController!.stream;
    _startListening();
  }

  Stream<Position> get positionStream {
    return _positionStream ?? Stream.empty();
  }

  void _startListening() {
    if (_isListening) return; // Prevent duplicate listeners
    _isListening = true;

    _geolocatorSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          _positionController?.add(position);
        });
  }

  Future<Position?> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void dispose() {
    _geolocatorSubscription?.cancel();
    _positionController?.close();
    _isListening = false;
  }
}
