import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/alert_provider.dart';
import '../providers/traffic_provider.dart';
import '../models/alert_model.dart';

class AlertoScreen extends StatefulWidget {
  const AlertoScreen({super.key});

  @override
  State<AlertoScreen> createState() => _AlertoScreenState();
}

class _AlertoScreenState extends State<AlertoScreen> {
  AlertType? _selectedAlertType;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AlertProvider, TrafficProvider>(
      builder: (context, alertProvider, trafficProvider, child) {
        final nearbyAlerts = trafficProvider.currentPosition != null
            ? alertProvider.getNearbyAlerts(
                trafficProvider.currentPosition!.latitude,
                trafficProvider.currentPosition!.longitude,
              )
            : [];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Traffic Alerts'),
            backgroundColor: SugboColors.navy,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report alert section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SugboColors.cardNavy,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: SugboColors.accentAmber),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Report Traffic Alert',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'What caused the slowdown?',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AlertType.values.map((alertType) {
                          return ChoiceChip(
                            label: Text(alertType.emoji),
                            labelStyle: const TextStyle(fontSize: 20),
                            selected: _selectedAlertType == alertType,
                            onSelected: (selected) {
                              setState(() {
                                _selectedAlertType = selected
                                    ? alertType
                                    : null;
                              });
                            },
                            backgroundColor: Colors.transparent,
                            selectedColor: SugboColors.accentAmber,
                            side: BorderSide(
                              color: _selectedAlertType == alertType
                                  ? SugboColors.accentAmber
                                  : Colors.white30,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SugboColors.accentAmber,
                          ),
                          onPressed:
                              _selectedAlertType == null ||
                                  trafficProvider.currentPosition == null
                              ? null
                              : () async {
                                  await alertProvider.reportAlert(
                                    type: _selectedAlertType!,
                                    latitude: trafficProvider
                                        .currentPosition!
                                        .latitude,
                                    longitude: trafficProvider
                                        .currentPosition!
                                        .longitude,
                                    zoneName: trafficProvider.currentZone,
                                  );
                                  setState(() => _selectedAlertType = null);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Alert reported!'),
                                    ),
                                  );
                                },
                          child: const Text(
                            'CONFIRM & SEND',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Nearby alerts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Alerts (${nearbyAlerts.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (nearbyAlerts.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    child: const Text(
                      'No alerts nearby',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: nearbyAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = nearbyAlerts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: _getAlertColor(alert.type),
                        child: ListTile(
                          leading: Text(
                            alert.type.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            alert.type.displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(alert.zoneName),
                              Text(
                                'Reports: ${alert.reportCount}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Text(
                            _getTimeAgo(alert.createdAt),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),
                // All alerts
                const Text(
                  'All Active Alerts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (alertProvider.activeAlerts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text('No active alerts')),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alertProvider.activeAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = alertProvider.activeAlerts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Text(
                            alert.type.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          title: Text(
                            '${alert.type.displayName} at ${alert.zoneName}',
                          ),
                          subtitle: Text('Reports: ${alert.reportCount}'),
                          trailing: Text(
                            _getTimeAgo(alert.createdAt),
                            style: const TextStyle(fontSize: 11),
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

  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.accident:
        return Colors.red.withOpacity(0.2);
      case AlertType.roadConstruction:
        return Colors.orange.withOpacity(0.2);
      case AlertType.flooding:
        return Colors.blue.withOpacity(0.2);
      case AlertType.event:
        return Colors.purple.withOpacity(0.2);
      case AlertType.brokenTrafficLight:
        return Colors.yellow.withOpacity(0.2);
      case AlertType.unknown:
        return Colors.grey.withOpacity(0.2);
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
