import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_the_fuel/models/fuel_station.dart';
import 'package:save_the_fuel/providers/app_state.dart';

class PresyoBoardScreen extends StatelessWidget {
  const PresyoBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final cheapest = state.cheapestStationForProfile;
        final sorted = List<FuelStation>.from(state.stations)
          ..sort(
            (a, b) => a
                .priceFor(state.selectedFuelType)
                .compareTo(b.priceFor(state.selectedFuelType)),
          );
        return Scaffold(
          appBar: AppBar(title: const Text('Presyo Board')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                child: Row(
                  children: [
                    const Text('Sakay Profile Fuel: ', style: TextStyle(color: Colors.white70)),
                    DropdownButton<FuelType>(
                      value: state.selectedFuelType,
                      dropdownColor: const Color(0xFF0F1A2C),
                      onChanged: (value) {
                        if (value != null) state.setFuelType(value);
                      },
                      items: FuelType.values
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(fuelTypeLabel(type)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: sorted.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final station = sorted[index];
                    final price = station.priceFor(state.selectedFuelType);
                    final delta = station.deltaFor(state.selectedFuelType);
                    final cheapestHit = station.name == cheapest.name;
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F1A2C),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: cheapestHit ? const Color(0xFF00E676) : const Color(0xFF1C355C),
                          width: cheapestHit ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF12345A), Color(0xFF1D4F8C)],
                              ),
                            ),
                            child: const Icon(Icons.local_gas_station, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      station.brand,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    if (cheapestHit)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(Icons.verified, color: Color(0xFF00E676), size: 16),
                                      ),
                                  ],
                                ),
                                Text(
                                  station.name,
                                  style: const TextStyle(color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₱${price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: cheapestHit ? const Color(0xFF00E676) : Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    delta <= 0 ? Icons.south_east : Icons.north_east,
                                    size: 15,
                                    color: delta <= 0 ? const Color(0xFF00E676) : const Color(0xFFFF4D4D),
                                  ),
                                  Text(
                                    '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(2)} vs last week',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: delta <= 0
                                          ? const Color(0xFF00E676)
                                          : const Color(0xFFFF4D4D),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
