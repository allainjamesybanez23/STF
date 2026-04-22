import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:save_the_fuel/data/cebu_seed_data.dart';
import 'package:save_the_fuel/models/geofence.dart';
import 'package:save_the_fuel/providers/app_state.dart';
import 'package:save_the_fuel/widgets/peripheral_glow.dart';

class HudScreen extends StatelessWidget {
  const HudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final pulseRed = state.activeZoneType == ZoneType.red && state.redZoneSlowSeconds >= 10;
        final color = zoneColor(state.activeZoneType);
        final center = state.currentPosition == null
            ? const LatLng(10.3157, 123.8854)
            : LatLng(state.currentPosition!.latitude, state.currentPosition!.longitude);

        return Stack(
          children: [
            PeripheralGlowContainer(
              glowColor: color,
              pulse: pulseRed,
              child: FlutterMap(
                options: MapOptions(initialCenter: center, initialZoom: 14),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    maxZoom: 19,
                    userAgentPackageName: 'com.example.save_the_fuel',
                  ),
                  // Fallback endpoint for networks that block main OSM host.
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    maxZoom: 19,
                    userAgentPackageName: 'sugbo.save.mvp',
                  ),
                  if (state.pathTrail.length > 1)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: state.pathTrail,
                          color: Colors.black.withAlpha(130),
                          strokeWidth: 8,
                        ),
                        Polyline(
                          points: state.pathTrail,
                          color: Colors.cyanAccent.withAlpha(245),
                          strokeWidth: 4.5,
                        ),
                      ],
                    ),
                  CircleLayer(
                    circles: cebuGeofences
                        .where((zone) => zone.type == ZoneType.red || zone.type == ZoneType.amber)
                        .map(
                          (zone) => CircleMarker(
                            point: zone.center,
                            useRadiusInMeter: true,
                            radius: zone.radiusMeters,
                            color: zoneColor(zone.type).withAlpha(50),
                            borderColor: zoneColor(zone.type),
                            borderStrokeWidth: 2.5,
                          ),
                        )
                        .toList(),
                  ),
                  MarkerLayer(
                    markers: cebuTrafficStops
                        .map(
                          (stop) => Marker(
                            point: stop.position,
                            width: 130,
                            height: 76,
                            child: _TrafficStopMarker(stop: stop),
                          ),
                        )
                        .toList(),
                  ),
                  if (state.currentPosition != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: center,
                          width: 86,
                          height: 86,
                          child: const _DeviceMarker(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.15,
                    colors: [
                      color.withAlpha(24),
                      color.withAlpha(84),
                    ],
                  ),
                ),
              ),
            ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color.withAlpha(245),
                    width: pulseRed ? 18 : 13,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 56,
              left: 14,
              right: 14,
              child: _HudTopCard(
                speed: state.speedKph,
                prompt: state.hudPrompt,
                activeFence: state.activeFence?.name ?? 'Cebu Free Drive',
              ),
            ),
            Positioned(
              top: 56,
              right: 18,
              child: _SavingsBubble(amount: state.todayPhpSaved),
            ),
          ],
        );
      },
    );
  }
}

class _TrafficStopMarker extends StatelessWidget {
  const _TrafficStopMarker({required this.stop});

  final TrafficStopPoint stop;

  @override
  Widget build(BuildContext context) {
    final color = zoneColor(stop.type);
    final icon = stop.type == ZoneType.red ? Icons.traffic : Icons.traffic_outlined;
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xD9151B2A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                stop.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceMarker extends StatelessWidget {
  const _DeviceMarker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.cyanAccent.withAlpha(45),
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.lightBlueAccent.withAlpha(135),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withAlpha(170),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const Icon(
          Icons.navigation_rounded,
          size: 24,
          color: Colors.white,
        ),
      ],
    );
  }
}

class _HudTopCard extends StatelessWidget {
  const _HudTopCard({
    required this.speed,
    required this.prompt,
    required this.activeFence,
  });

  final double speed;
  final String prompt;
  final String activeFence;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 285,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xCC08111F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${speed.toStringAsFixed(1)} km/h',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(activeFence, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 9),
            Text(
              prompt,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavingsBubble extends StatelessWidget {
  const _SavingsBubble({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xDD0C1B2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00C853)),
      ),
      child: Column(
        children: [
          const Text('Today Saved', style: TextStyle(fontSize: 12, color: Colors.white70)),
          Text(
            '₱${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF00C853),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
