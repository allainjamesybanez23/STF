import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/earnings_provider.dart';

class EarningsTrackerScreen extends StatefulWidget {
  const EarningsTrackerScreen({super.key});

  @override
  State<EarningsTrackerScreen> createState() => _EarningsTrackerScreenState();
}

class _EarningsTrackerScreenState extends State<EarningsTrackerScreen> {
  final _boundaryController = TextEditingController();
  final _passengerController = TextEditingController();
  final _fuelCostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<EarningsProvider>(
      builder: (context, earningsProvider, child) {
        final currentWeek = earningsProvider.currentWeeklyEarnings;
        final lastWeek = earningsProvider.lastWeeklyEarnings;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Daily Earnings'),
            backgroundColor: SugboColors.navy,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current week summary
                if (currentWeek != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: SugboColors.cardNavy,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'This Week',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PHP ${currentWeek.totalEarnings.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: SugboColors.accentAmber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildWeekStat(
                              'Saved',
                              'PHP ${currentWeek.totalFuelSaved.toStringAsFixed(2)}',
                            ),
                            _buildWeekStat(
                              'Days',
                              '${currentWeek.records.length}',
                            ),
                            _buildWeekStat(
                              'Avg/Day',
                              'PHP ${currentWeek.averageDailyEarnings.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                        if (lastWeek != null &&
                            lastWeek.records.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${currentWeek.getImprovementPercentage(lastWeek) > 0 ? '+' : ''}${currentWeek.getImprovementPercentage(lastWeek).toStringAsFixed(1)}% vs last week',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                // Log new earnings
                const Text(
                  'Log Shift',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _boundaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Boundary Fee (PHP)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passengerController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Passenger Count',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _fuelCostController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Fuel Cost (PHP)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SugboColors.accentAmber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      earningsProvider.logShiftEarnings(
                        boundaryFee: double.parse(_boundaryController.text),
                        passengerCount: int.parse(_passengerController.text),
                        totalFuelCostUsed: double.parse(
                          _fuelCostController.text,
                        ),
                      );
                      _boundaryController.clear();
                      _passengerController.clear();
                      _fuelCostController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Earnings logged')),
                      );
                    },
                    child: const Text(
                      'LOG EARNINGS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),
                const Text(
                  'Earnings History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (earningsProvider.records.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text('No earnings logged')),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: earningsProvider.records.length,
                    itemBuilder: (context, index) {
                      final record = earningsProvider.records[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            'PHP ${record.netEarnings.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${record.passengerCount} passengers | Fuel: PHP ${record.totalFuelCostUsed.toStringAsFixed(2)}',
                          ),
                          trailing: Text(
                            record.date.toString().split(' ')[0],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeekStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _boundaryController.dispose();
    _passengerController.dispose();
    _fuelCostController.dispose();
    super.dispose();
  }
}
