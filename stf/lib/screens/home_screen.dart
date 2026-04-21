import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/traffic_provider.dart';
import 'hud_screen.dart';
import 'map_screen.dart';
import 'alerto_screen.dart';
import 'lakaw_tracker_screen.dart';
import 'earnings_tracker_screen.dart';
import 'savings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<TrafficProvider>(
      builder: (context, provider, child) {
        final screens = [
          HUDScreen(),
          MapScreen(),
          AlertoScreen(),
          LakawTrackerScreen(),
          EarningsTrackerScreen(),
          SavingsScreen(),
        ];
        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: screens),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: SugboColors.cardNavy,
            selectedItemColor: SugboColors.accentAmber,
            unselectedItemColor: Colors.white54,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'HUD',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning_amber),
                label: 'Alerts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.navigation),
                label: 'Lakaw',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: 'Earnings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.savings),
                label: 'Savings',
              ),
            ],
          ),
        );
      },
    );
  }
}
