// Widget smoke test for MedDropApp.
//
// The original counter smoke test was removed because main.dart was fully
// replaced with the Clean Architecture entry point (MedDropApp). This file
// provides a minimal compilation check that confirms the app widget tree
// inflates without throwing.

import 'package:flutter_test/flutter_test.dart';

import 'package:med_drop/main.dart';

void main() {
  testWidgets('MedDropApp renders without error', (WidgetTester tester) async {
    // MedDropApp itself is a pure MaterialApp widget with no async DI calls
    // at build time — the DI init() is awaited in main() before runApp().
    // We can safely pump it in isolation here.
    await tester.pumpWidget(const MedDropApp());

    // The placeholder screen should render the app name.
    expect(find.text('MedDrop'), findsOneWidget);
  });
}
