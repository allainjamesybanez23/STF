import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/traffic_provider.dart';

class HUDScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // BIG ZONE INDICATOR
            Expanded(
              child: Center(
                child: Consumer<TrafficProvider>(
                  builder: (context, provider, _) {
                    return provider.isLoading
                        ? CircularProgressIndicator(
                            color: SugboColors.accentAmber,
                          )
                        : _buildZoneIndicator(provider.currentZone);
                  },
                ),
              ),
            ),
            // AI TIP BANNER
            Consumer<TrafficProvider>(
              builder: (context, provider, _) {
                return _buildTipBanner(provider.currentZone);
              },
            ),
            // REPORT BUTTON
            _buildReportButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneIndicator(String zone) {
    return RepaintBoundary(
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getZoneColor(zone),
          boxShadow: [
            BoxShadow(
              color: _getZoneColor(zone).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                zone,
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                zone == 'RED'
                    ? 'SLOW DOWN'
                    : zone == 'CAUTION'
                    ? 'CAUTION'
                    : 'GO CLEAR',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipBanner(String zone) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: SugboColors.cardNavy,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          _getBisayaTip(zone),
          style: const TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 70,
        width: double.infinity,
        child: Consumer<TrafficProvider>(
          builder: (context, provider, _) {
            return ElevatedButton.icon(
              icon: const Icon(Icons.warning_amber, color: Colors.black),
              label: const Text(
                "REPORT ACCIDENT",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SugboColors.accentAmber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: provider.reportAccident,
            );
          },
        ),
      ),
    );
  }

  Color _getZoneColor(String zone) {
    switch (zone) {
      case 'RED':
        return SugboColors.redZone;
      case 'CAUTION':
        return SugboColors.cautionAmber;
      default:
        return SugboColors.greenZone;
    }
  }

  String _getBisayaTip(String zone) {
    switch (zone) {
      case 'RED':
        return 'Pula ang zone, patya ang makina para makatipid.';
      case 'CAUTION':
        return 'Caution, andam pag-drive.';
      default:
        return 'Bukas ang dalan, padayon lang.';
    }
  }
}
