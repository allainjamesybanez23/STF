import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:stf/main.dart' as app;
import 'package:stf/providers/traffic_provider.dart';

void main() {
  testWidgets('App loads HUD', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TrafficProvider(),
        child: const app.SugboRouteApp(),
      ),
    );
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
