import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/traffic_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/trip_provider.dart';
import 'providers/earnings_provider.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Setup Firebase project first
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TrafficProvider()),
        ChangeNotifierProvider(create: (context) => AlertProvider()),
        ChangeNotifierProvider(create: (context) => TripProvider()),
        ChangeNotifierProvider(create: (context) => EarningsProvider()),
      ],
      child: const SugboRouteApp(),
    ),
  );
}

class SugboRouteApp extends StatelessWidget {
  const SugboRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: SugboColors.navy,
      ),
      home: const HomeScreen(),
    );
  }
}
