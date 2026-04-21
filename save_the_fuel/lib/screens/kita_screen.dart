import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_the_fuel/providers/app_state.dart';

class KitaScreen extends StatelessWidget {
  const KitaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final bars = state.weeklyNetIncomeSeries;
        return Scaffold(
          appBar: AppBar(title: const Text('Kita Karong Adlaw')),
          body: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1A2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('WEEKLY NET INCOME (PHP)', style: TextStyle(letterSpacing: 1.1)),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 170,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(bars.length, (index) {
                          final value = bars[index];
                          final maxVal = bars.reduce((a, b) => a > b ? a : b);
                          final isPeak = value == maxVal;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    value.toStringAsFixed(0),
                                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 110 * (value / maxVal),
                                    decoration: BoxDecoration(
                                      color: isPeak ? const Color(0xFF00C853) : const Color(0xFF378ADD),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index]),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1A2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HOURLY NET INCOME HEAT'),
                    const SizedBox(height: 8),
                    ...state.hourlyNetIncome.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(width: 62, child: Text('${entry.key}:00')),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: entry.value / 160,
                                minHeight: 8,
                                color: entry.value > 120
                                    ? const Color(0xFF00E676)
                                    : const Color(0xFF378ADD),
                                backgroundColor: const Color(0xFF233D62),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('₱${entry.value.toStringAsFixed(0)}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Most profitable hour: ${state.bestProfitHour}:00 - ${(state.bestProfitHour + 1).toString().padLeft(2, '0')}:00',
                      style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
