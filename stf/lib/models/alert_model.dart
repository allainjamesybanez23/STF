import 'package:cloud_firestore/cloud_firestore.dart';

enum AlertType {
  accident,
  roadConstruction,
  flooding,
  event,
  brokenTrafficLight,
  unknown;

  String get displayName {
    switch (this) {
      case AlertType.accident:
        return 'Accident';
      case AlertType.roadConstruction:
        return 'Road Construction';
      case AlertType.flooding:
        return 'Flooding';
      case AlertType.event:
        return 'Event or Fiesta';
      case AlertType.brokenTrafficLight:
        return 'Broken Traffic Light';
      case AlertType.unknown:
        return 'Unknown Issue';
    }
  }

  String get emoji {
    switch (this) {
      case AlertType.accident:
        return '🚗';
      case AlertType.roadConstruction:
        return '🚧';
      case AlertType.flooding:
        return '🌊';
      case AlertType.event:
        return '🎉';
      case AlertType.brokenTrafficLight:
        return '🚦';
      case AlertType.unknown:
        return '❓';
    }
  }

  static AlertType fromString(String value) {
    return AlertType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AlertType.unknown,
    );
  }
}

class Alert {
  final String id;
  final double latitude;
  final double longitude;
  final AlertType type;
  final String zoneName;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int reportCount;
  final String createdByUserId;

  Alert({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.zoneName,
    required this.createdAt,
    required this.createdByUserId,
  }) : expiresAt = createdAt.add(const Duration(minutes: 45)),
       reportCount = 1;

  factory Alert.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Alert(
      id: doc.id,
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      type: AlertType.fromString(data['type'] ?? 'unknown'),
      zoneName: data['zoneName'] ?? 'Unknown',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdByUserId: data['createdByUserId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'type': type.name,
      'zoneName': zoneName,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'reportCount': reportCount,
      'createdByUserId': createdByUserId,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
