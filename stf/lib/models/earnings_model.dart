import 'package:cloud_firestore/cloud_firestore.dart';

class EarningsRecord {
  final String id;
  final DateTime date;
  final double boundaryFee;
  final int passengerCount;
  final double totalFuelCostUsed;
  final double netEarnings; // boundaryFee - totalFuelCostUsed

  EarningsRecord({
    required this.id,
    required this.date,
    required this.boundaryFee,
    required this.passengerCount,
    required this.totalFuelCostUsed,
  }) : netEarnings = boundaryFee - totalFuelCostUsed;

  factory EarningsRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EarningsRecord(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      boundaryFee: data['boundaryFee'] ?? 0.0,
      passengerCount: data['passengerCount'] ?? 0,
      totalFuelCostUsed: data['totalFuelCostUsed'] ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'boundaryFee': boundaryFee,
      'passengerCount': passengerCount,
      'totalFuelCostUsed': totalFuelCostUsed,
      'netEarnings': netEarnings,
    };
  }
}

class WeeklyEarnings {
  final List<EarningsRecord> records;

  WeeklyEarnings(this.records);

  double get totalEarnings =>
      records.fold(0, (sum, record) => sum + record.netEarnings);

  double get totalFuelSaved =>
      records.fold(0, (sum, record) => sum + record.totalFuelCostUsed);

  int get totalPassengers =>
      records.fold(0, (sum, record) => sum + record.passengerCount);

  double get averageDailyEarnings =>
      records.isEmpty ? 0 : totalEarnings / records.length;

  // Earnings improvement percentage compared to last week
  double getImprovementPercentage(WeeklyEarnings previousWeek) {
    if (previousWeek.totalEarnings == 0) return 0;
    return ((totalEarnings - previousWeek.totalEarnings) /
            previousWeek.totalEarnings) *
        100;
  }
}
