// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:app1/main.dart'; // Ensure this matches the package name in pubspec.yaml

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app shows the title 'SHOP'.
    expect(find.text('SHOP'), findsOneWidget);

    // Verify that the app shows the initial points.
    expect(find.text('300 Points'), findsOneWidget);
  });
}
