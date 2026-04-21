import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';

class TripModel {
  final String id;
  final VehicleType vehicleType;
  final double startLat;
  final double startLng;
  final double? endLat;
  final double? endLng;
  final DateTime startTime;
  final DateTime? endTime;
  final double distanceKm;
  final double fuelPrice; // PHP per liter
  final int redZoneMinutes;
  final int cautionZoneMinutes;

  // Calculated fields
  double get fuelUsed => distanceKm / vehicleType.kmPerLiter;
  double get fuelCost => (distanceKm / vehicleType.kmPerLiter) * fuelPrice;
  double get idlingSavings => FuelSavingsCalculator.estimateIdlingSavings(
    redZoneMinutes.toDouble(),
    vehicleType.kmPerLiter,
    fuelPrice,
  );
  double get netSavings => idlingSavings;

  // Trip duration in minutes
  int get durationMinutes {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inMinutes;
  }

  // Average speed
  double get averageSpeed {
    if (durationMinutes == 0) return 0;
    return (distanceKm / (durationMinutes / 60));
  }

  // Estimated arrival time (for active trips)
  DateTime? get estimatedArrival {
    if (endTime != null) return null; // Trip already ended
    // Placeholder - would need destination distance
    return null;
  }

  TripModel({
    required this.id,
    required this.vehicleType,
    required this.startLat,
    required this.startLng,
    required this.startTime,
    required this.distanceKm,
    required this.fuelPrice,
    this.endLat,
    this.endLng,
    this.endTime,
    this.redZoneMinutes = 0,
    this.cautionZoneMinutes = 0,
  });

  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripModel(
      id: doc.id,
      vehicleType: VehicleType.values.byName(
        data['vehicleType'] ?? 'modernJeep',
      ),
      startLat: data['startLat'] ?? 0.0,
      startLng: data['startLng'] ?? 0.0,
      startTime: (data['startTime'] as Timestamp).toDate(),
      distanceKm: data['distanceKm'] ?? 0.0,
      fuelPrice: data['fuelPrice'] ?? 50.0,
      endLat: data['endLat'],
      endLng: data['endLng'],
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      redZoneMinutes: data['redZoneMinutes'] ?? 0,
      cautionZoneMinutes: data['cautionZoneMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vehicleType': vehicleType.name,
      'startLat': startLat,
      'startLng': startLng,
      'endLat': endLat,
      'endLng': endLng,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'distanceKm': distanceKm,
      'fuelPrice': fuelPrice,
      'redZoneMinutes': redZoneMinutes,
      'cautionZoneMinutes': cautionZoneMinutes,
      'fuelUsed': fuelUsed,
      'fuelCost': fuelCost,
      'netSavings': netSavings,
    };
  }
}
