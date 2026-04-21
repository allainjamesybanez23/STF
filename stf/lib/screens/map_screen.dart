import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/traffic_provider.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cebu Traffic Map'),
        backgroundColor: SugboColors.navy,
      ),
      body: const _MapView(),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(10.3157, 123.8854),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'stf',
        ),
        Consumer<TrafficProvider>(
          builder: (context, provider, _) {
            final position = provider.currentPosition != null
                ? LatLng(
                    provider.currentPosition!.latitude,
                    provider.currentPosition!.longitude,
                  )
                : const LatLng(10.3157, 123.8854);
            return CircleLayer(
              circles: [
                CircleMarker(
                  point: LatLng(position.latitude, position.longitude),
                  color: provider.currentZone == 'RED'
                      ? SugboColors.redZone.withOpacity(0.5)
                      : Colors.blue.withOpacity(0.5),
                  borderStrokeWidth: 3,
                  radius: 20,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
