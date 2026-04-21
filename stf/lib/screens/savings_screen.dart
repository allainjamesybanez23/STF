import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip_model.dart';
import '../theme.dart';
import '../providers/trip_provider.dart';
import '../providers/earnings_provider.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<TripProvider, EarningsProvider>(
      builder: (context, tripProvider, earningsProvider, child) {
        final totalFuelSaved = tripProvider.getTotalFuelSaved();
        final totalMoneySaved = tripProvider.getTotalMoneySaved();
        final weeklyEarnings = earningsProvider.currentWeeklyEarnings;

        return Scaffold(
          backgroundColor: SugboColors.navy,
          appBar: AppBar(
            title: const Text('Savings Card'),
            backgroundColor: SugboColors.cardNavy,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main savings card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        SugboColors.accentAmber,
                        SugboColors.accentAmber.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Today\'s Savings',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'PHP ${totalMoneySaved.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSavingsStat(
                            'Fuel Saved',
                            '${totalFuelSaved.toStringAsFixed(2)} L',
                            Colors.black87,
                          ),
                          _buildSavingsStat(
                            'Take-Home',
                            'PHP ${(weeklyEarnings?.totalEarnings ?? 0).toStringAsFixed(2)}',
                            Colors.black87,
                          ),
                          _buildSavingsStat(
                            'Efficiency',
                            '${((totalMoneySaved / (weeklyEarnings?.totalEarnings ?? 1)) * 100).toStringAsFixed(1)}%',
                            Colors.black87,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Trip statistics
                const Text(
                  'Trip Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (tripProvider.currentTrip != null) ...[
                  _buildStatCard(
                    'Active Trip',
                    'Distance: ${tripProvider.currentDistance.toStringAsFixed(1)} km',
                    SugboColors.greenZone,
                  ),
                  const SizedBox(height: 12),
                ] else if (tripProvider.tripHistory.isEmpty)
                  _buildEmptyState('No trips recorded yet')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tripProvider.tripHistory.length > 5
                        ? 5
                        : tripProvider.tripHistory.length,
                    itemBuilder: (context, index) {
                      final trip = tripProvider.tripHistory[index];
                      return _buildTripCard(trip);
                    },
                  ),
                const SizedBox(height: 32),
                // Weekly earnings
                if (weeklyEarnings != null) ...[
                  const Text(
                    'This Week',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    'Total Earnings',
                    'PHP ${weeklyEarnings.totalEarnings.toStringAsFixed(2)}',
                    SugboColors.accentAmber,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Average Daily',
                    'PHP ${weeklyEarnings.averageDailyEarnings.toStringAsFixed(2)}',
                    SugboColors.accentAmber,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavingsStat(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(TripModel trip) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: SugboColors.cardNavy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip.vehicleType.name} - ${trip.distanceKm.toStringAsFixed(1)} km',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Fuel: PHP ${trip.fuelCost.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Saved',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              Text(
                'PHP ${trip.netSavings.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: SugboColors.greenZone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Text(message, style: const TextStyle(color: Colors.white70)),
    );
  }
}
