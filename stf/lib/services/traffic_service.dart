import 'package:geolocator/geolocator.dart';

class TrafficZone {
  final String name;
  final double lat;
  final double lng;
  final String baseStatus; // RED, CAUTION, GREEN
  final String rushHourStatus; // Status during rush hours

  TrafficZone(
    this.name,
    this.lat,
    this.lng,
    this.baseStatus, [
    String? rushHourStatus,
  ]) : rushHourStatus = rushHourStatus ?? baseStatus;

  String getStatus({required bool isRushHour}) {
    return isRushHour ? rushHourStatus : baseStatus;
  }
}

class TrafficService {
  static const double ZONE_RADIUS = 500; // meters
  static const double MIN_DISTANCE_FOR_CHECK = 20; // meters

  late final List<TrafficZone> cebuZones;
  double? _lastLat;
  double? _lastLng;
  String _cachedZone = 'GREEN';

  TrafficService() {
    cebuZones = [
      // Zone name, lat, lng, base status, rush hour status
      TrafficZone("SRP Tunnel", 10.2990, 123.9200, "RED", "RED"),
      TrafficZone("Mactan Bridge", 10.25, 123.97, "RED", "RED"),
      TrafficZone("Mandaue Bridge", 10.3494, 123.9390, "RED", "RED"),
      TrafficZone("Colon Street", 10.2958, 123.8975, "CAUTION", "RED"),
      TrafficZone("Carbon Market", 10.2965, 123.8942, "CAUTION", "RED"),
      TrafficZone("Minglanilla", 10.2000, 123.8600, "CAUTION", "RED"),
      TrafficZone("IT Park", 10.3310, 123.9050, "GREEN", "CAUTION"),
      TrafficZone("Talisay", 10.1967, 123.8347, "GREEN", "CAUTION"),
    ];
  }

  bool _isRushHour() {
    final now = DateTime.now();
    final hour = now.hour;

    // Morning rush: 7-9 AM
    if (hour >= 7 && hour < 9) return true;

    // Evening rush: 5-7 PM
    if (hour >= 17 && hour < 19) return true;

    return false;
  }

  String checkZone(Position pos) {
    // Skip recalculation if position hasn't moved significantly
    if (_lastLat != null && _lastLng != null) {
      double moved = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        _lastLat!,
        _lastLng!,
      );
      if (moved < MIN_DISTANCE_FOR_CHECK) {
        return _cachedZone; // Return cached result
      }
    }

    _lastLat = pos.latitude;
    _lastLng = pos.longitude;

    final isRush = _isRushHour();

    for (var zone in cebuZones) {
      double distance = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        zone.lat,
        zone.lng,
      );
      if (distance < ZONE_RADIUS) {
        _cachedZone = zone.getStatus(isRushHour: isRush);
        return _cachedZone;
      }
    }
    _cachedZone = "GREEN";
    return "GREEN";
  }
}
