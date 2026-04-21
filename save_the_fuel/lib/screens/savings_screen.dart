import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_the_fuel/providers/app_state.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final projected = state.profileSavingsPerLiter * 4 * 40;
        final withSugbo = 2380 - state.todayPhpSaved;
        return Scaffold(
          appBar: AppBar(title: const Text('Savings')),
          body: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF08B858),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('IMU NGA SAVINGS'),
                      const SizedBox(height: 8),
                      Text(
                        '₱ ${state.todayPhpSaved.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const LinearProgressIndicator(
                        value: 0.62,
                        minHeight: 8,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1A2C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _row('Without SUGBO-SAVE', '₱2,380', const Color(0xFFFF4D4D)),
                      _row('With SUGBO-SAVE', '₱${withSugbo.toStringAsFixed(0)}', const Color(0xFF378ADD)),
                      _row('Nailhan nga Savings', '₱ ${state.todayPhpSaved.toStringAsFixed(0)} saved', const Color(0xFF00E676)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1A2C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _row('Projected Weekly Savings', '₱ ${projected.toStringAsFixed(0)}', const Color(0xFF00E676)),
                      _row('Fuel Avoided (est.)', '~${(state.todayLitersSaved * 3).toStringAsFixed(1)} L', const Color(0xFFFFC107)),
                      _row('Idle Events Prevented', '${(state.idleSeconds / 300).floor() + 3}', const Color(0xFF378ADD)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _row(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
