import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum ZoneType { red, amber, green }

class Geofence {
  const Geofence({
    required this.name,
    required this.center,
    required this.radiusMeters,
    required this.type,
  });

  final String name;
  final LatLng center;
  final double radiusMeters;
  final ZoneType type;
}

class TrafficRoadSegment {
  const TrafficRoadSegment({
    required this.name,
    required this.type,
    required this.points,
  });

  final String name;
  final ZoneType type;
  final List<LatLng> points;
}

class TrafficStopPoint {
  const TrafficStopPoint({
    required this.name,
    required this.position,
    required this.type,
    required this.note,
  });

  final String name;
  final LatLng position;
  final ZoneType type;
  final String note;
}

Color zoneColor(ZoneType type) {
  switch (type) {
    case ZoneType.red:
      return const Color(0xFFFF4D4D);
    case ZoneType.amber:
      return const Color(0xFFFFAA00);
    case ZoneType.green:
      return const Color(0xFF00C853);
  }
}
