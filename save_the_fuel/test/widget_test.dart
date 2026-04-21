// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_fuel/main.dart';
import 'package:save_the_fuel/providers/app_state.dart';

void main() {
  testWidgets('SUGBO-SAVE renders root navigation', (WidgetTester tester) async {
    await tester.pumpWidget(SugboSaveApp(appState: AppState()));
    expect(find.text('Lakaw'), findsOneWidget);
    expect(find.text('Presyo'), findsOneWidget);
    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Savings'), findsOneWidget);
    expect(find.text('Kita'), findsOneWidget);
  });
}
