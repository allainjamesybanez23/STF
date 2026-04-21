import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:save_the_fuel/providers/app_state.dart';
import 'package:save_the_fuel/screens/hud_screen.dart';
import 'package:save_the_fuel/screens/kita_screen.dart';
import 'package:save_the_fuel/screens/presyo_board_screen.dart';
import 'package:save_the_fuel/screens/savings_screen.dart';
import 'package:save_the_fuel/screens/summary_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.initialize();
  runApp(SugboSaveApp(appState: appState));
}

class SugboSaveApp extends StatelessWidget {
  const SugboSaveApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.rajdhaniTextTheme(
      ThemeData.dark().textTheme,
    );

    return ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(
        title: 'SUGBO-SAVE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF060A12),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF378ADD),
            secondary: Color(0xFF00C853),
            surface: Color(0xFF101826),
          ),
          textTheme: baseTextTheme.copyWith(
            bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
        home: const _RootShell(),
      ),
    );
  }
}

class _RootShell extends StatefulWidget {
  const _RootShell();

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HudScreen(),
      PresyoBoardScreen(),
      SummaryScreen(),
      SavingsScreen(),
      KitaScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Lakaw'),
          NavigationDestination(
            icon: Icon(Icons.local_gas_station),
            label: 'Presyo',
          ),
          NavigationDestination(icon: Icon(Icons.summarize), label: 'Summary'),
          NavigationDestination(icon: Icon(Icons.savings), label: 'Savings'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'Kita'),
        ],
      ),
    );
  }
}
