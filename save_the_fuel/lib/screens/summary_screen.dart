import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_the_fuel/providers/app_state.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final savings = state.todayPhpSaved;
        return Scaffold(
          appBar: AppBar(title: const Text('Summary')),
          body: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F2D25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NAILHAN NGA SAVINGS', style: TextStyle(letterSpacing: 1.1)),
                      const SizedBox(height: 8),
                      Text(
                        '₱ ${savings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00E676),
                        ),
                      ),
                      Text(
                        '${state.todayLitersSaved.toStringAsFixed(2)} L avoided x ₱170/L',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _miniCard('12.4', 'KM\nTRAVELED'),
                    const SizedBox(width: 8),
                    _miniCard(state.todayLitersSaved.toStringAsFixed(1), 'LITRO\nSAVED'),
                    const SizedBox(width: 8),
                    _miniCard('3', 'ZONES\nRED HIT'),
                  ],
                ),
                const SizedBox(height: 14),
                _line('Idle Time', '${(state.idleSeconds ~/ 60).toString().padLeft(2, '0')}:${(state.idleSeconds % 60).toString().padLeft(2, '0')}', const Color(0xFFFF4D4D)),
                _line('Engine-off Events', '${(state.idleSeconds / 300).floor()}', const Color(0xFFFFC107)),
                _line('Green Time', '68%', const Color(0xFF00E676)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _miniCard(String value, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1A2C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1C355C)),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF00E676))),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
