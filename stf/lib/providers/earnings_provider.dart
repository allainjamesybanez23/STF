import 'package:flutter/foundation.dart';
import '../models/earnings_model.dart';

class EarningsProvider extends ChangeNotifier {
  late List<EarningsRecord> _records;
  WeeklyEarnings? _currentWeeklyEarnings;
  WeeklyEarnings? _lastWeeklyEarnings;

  List<EarningsRecord> get records => _records;
  WeeklyEarnings? get currentWeeklyEarnings => _currentWeeklyEarnings;
  WeeklyEarnings? get lastWeeklyEarnings => _lastWeeklyEarnings;

  EarningsProvider() {
    _loadHardcodedEarningsData();
  }

  void _loadHardcodedEarningsData() {
    // Initialize with hardcoded earnings records
    _records = [
      EarningsRecord(
        id: '1',
        date: DateTime.now().subtract(const Duration(days: 0)),
        boundaryFee: 500,
        passengerCount: 8,
        totalFuelCostUsed: 120,
      ),
      EarningsRecord(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 1)),
        boundaryFee: 450,
        passengerCount: 6,
        totalFuelCostUsed: 95,
      ),
      EarningsRecord(
        id: '3',
        date: DateTime.now().subtract(const Duration(days: 2)),
        boundaryFee: 520,
        passengerCount: 7,
        totalFuelCostUsed: 110,
      ),
      EarningsRecord(
        id: '4',
        date: DateTime.now().subtract(const Duration(days: 3)),
        boundaryFee: 480,
        passengerCount: 5,
        totalFuelCostUsed: 85,
      ),
    ];

    _calculateWeeklyEarnings();
    notifyListeners();
  }

  void _calculateWeeklyEarnings() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final lastWeekStart = weekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));

    // Current week earnings
    final currentWeekRecords = _records.where((r) {
      final rDate = DateTime(r.date.year, r.date.month, r.date.day);
      return !rDate.isBefore(weekStart) && !rDate.isAfter(today);
    }).toList();
    _currentWeeklyEarnings = WeeklyEarnings(currentWeekRecords);

    // Last week earnings
    final lastWeekRecords = _records.where((r) {
      final rDate = DateTime(r.date.year, r.date.month, r.date.day);
      return !rDate.isBefore(lastWeekStart) && !rDate.isAfter(lastWeekEnd);
    }).toList();
    _lastWeeklyEarnings = WeeklyEarnings(lastWeekRecords);
  }

  Future<void> logShiftEarnings({
    required double boundaryFee,
    required int passengerCount,
    required double totalFuelCostUsed,
  }) async {
    try {
      final record = EarningsRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        boundaryFee: boundaryFee,
        passengerCount: passengerCount,
        totalFuelCostUsed: totalFuelCostUsed,
      );

      _records.insert(0, record);
      _calculateWeeklyEarnings();
      print('Earnings logged: PHP ${record.boundaryFee}');
      notifyListeners();
    } catch (e) {
      print('Error logging earnings: $e');
    }
  }

  // Get earnings for specific date
  EarningsRecord? getEarningsForDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    try {
      return _records.firstWhere((record) {
        final recordDate = DateTime(
          record.date.year,
          record.date.month,
          record.date.day,
        );
        return recordDate == dateOnly;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
