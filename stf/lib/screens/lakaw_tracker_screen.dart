import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/trip_provider.dart';
import '../models/vehicle_model.dart';

class LakawTrackerScreen extends StatefulWidget {
  const LakawTrackerScreen({super.key});

  @override
  State<LakawTrackerScreen> createState() => _LakawTrackerScreenState();
}

class _LakawTrackerScreenState extends State<LakawTrackerScreen> {
  VehicleType? _selectedVehicle;
  final _fuelPriceController = TextEditingController(text: '50');

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final isTripping = tripProvider.currentTrip != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lakaw Tracker'),
            backgroundColor: SugboColors.navy,
          ),
          body: isTripping
              ? _buildActiveTrip(context, tripProvider)
              : _buildStartTrip(context, tripProvider),
        );
      },
    );
  }

  Widget _buildStartTrip(BuildContext context, TripProvider tripProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start a New Trip',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Text(
            'Vehicle Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          DropdownButton<VehicleType>(
            isExpanded: true,
            value: _selectedVehicle,
            hint: const Text('Select vehicle type'),
            items: VehicleType.values.map((VehicleType vehicle) {
              return DropdownMenuItem<VehicleType>(
                value: vehicle,
                child: Text('${vehicle.name} (${vehicle.kmPerLiter} km/L)'),
              );
            }).toList(),
            onChanged: (VehicleType? newValue) {
              setState(() => _selectedVehicle = newValue);
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Fuel Price (PHP per liter)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fuelPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Enter fuel price',
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SugboColors.accentAmber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _selectedVehicle == null
                  ? null
                  : () async {
                      await tripProvider.startTrip(
                        _selectedVehicle!,
                        double.parse(_fuelPriceController.text),
                      );
                    },
              child: const Text(
                'START TRIP',
                style: TextStyle(
                  fontSize: 16,
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
            'Trip History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (tripProvider.tripHistory.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No trips yet')),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tripProvider.tripHistory.length,
              itemBuilder: (context, index) {
                final trip = tripProvider.tripHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      '${trip.vehicleType.name} - ${trip.distanceKm.toStringAsFixed(1)} km',
                    ),
                    subtitle: Text(
                      'Fuel: PHP ${trip.fuelCost.toStringAsFixed(2)} | Saved: PHP ${trip.netSavings.toStringAsFixed(2)}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          trip.durationMinutes > 0
                              ? '${(trip.durationMinutes / 60).toStringAsFixed(1)}h'
                              : 'Active',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActiveTrip(BuildContext context, TripProvider tripProvider) {
    final trip = tripProvider.currentTrip!;
    final durationMinutes = tripProvider.getCurrentTripDurationMinutes();
    final fuelUsed = tripProvider.currentDistance / trip.vehicleType.kmPerLiter;
    final fuelCost = fuelUsed * trip.fuelPrice;
    final avgSpeed = durationMinutes > 0
        ? (tripProvider.currentDistance / durationMinutes * 60).toStringAsFixed(
            1,
          )
        : '0';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Main distance display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SugboColors.cardNavy,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  'Distance',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  '${tripProvider.currentDistance.toStringAsFixed(2)} km',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Avg Speed: $avgSpeed km/h',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBox(
                      'Duration',
                      durationMinutes > 60
                          ? '${(durationMinutes / 60).toStringAsFixed(1)}h'
                          : '${durationMinutes}m',
                    ),
                    _buildStatBox(
                      'Fuel Used',
                      '${fuelUsed.toStringAsFixed(2)} L',
                    ),
                    _buildStatBox(
                      'Fuel Cost',
                      'PHP ${fuelCost.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Zone time breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SugboColors.cardNavy,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Traffic Zones',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          '🔴 Heavy Traffic',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${tripProvider.redZoneTime ~/ 60} min',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          '🟡 Moderate',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${tripProvider.cautionZoneTime ~/ 60} min',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          '🟢 Clear',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(durationMinutes - tripProvider.redZoneTime ~/ 60 - tripProvider.cautionZoneTime ~/ 60).abs()} min',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await tripProvider.endTrip();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Trip ended! Distance: ${tripProvider.currentDistance.toStringAsFixed(2)} km',
                    ),
                  ),
                );
              },
              child: const Text(
                'END TRIP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fuelPriceController.dispose();
    super.dispose();
  }
}
