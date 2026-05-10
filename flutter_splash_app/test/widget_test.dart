import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_splash_app/app.dart';

void main() {
  testWidgets('Splash screen displays and navigates correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify that the splash screen is displayed
    expect(find.text('Splash Screen'), findsOneWidget);

    // Simulate waiting for the splash screen duration
    await tester.pumpAndSettle(Duration(seconds: 3));

    // Verify that the app navigates to the correct screen based on login state
    // Assuming the user is not logged in, it should navigate to the LoginScreen
    expect(find.text('Login Screen'), findsOneWidget);
  });
}