import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_the_fuel/providers/app_state.dart';

class BoostScreen extends StatelessWidget {
  const BoostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final takeHome = state.currentEarningsPhp + state.todayPhpSaved;
        return Scaffold(
          appBar: AppBar(title: const Text('Take-Home Boost')),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              width: 420,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF00C853), width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'EARNINGS CARD',
                    style: TextStyle(
                      color: Color(0xFF00C853),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _kpi('Total Liters Saved', '${state.todayLitersSaved.toStringAsFixed(3)} L'),
                  _kpi('Total PHP Saved', '₱${state.todayPhpSaved.toStringAsFixed(2)}'),
                  _kpi('Current Earnings', '₱${state.currentEarningsPhp.toStringAsFixed(2)}'),
                  const Divider(color: Colors.white24, height: 22),
                  _kpi(
                    'New Daily Take-home',
                    '₱${takeHome.toStringAsFixed(2)}',
                    valueColor: const Color(0xFF00C853),
                    valueSize: 32,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _kpi(
    String title,
    String value, {
    Color valueColor = Colors.white,
    double valueSize = 22,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(fontSize: valueSize, color: valueColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
