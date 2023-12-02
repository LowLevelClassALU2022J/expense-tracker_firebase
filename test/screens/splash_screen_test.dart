import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/screens/splash_screen.dart';

void main() {
  group('SplashScreen Tests', () {
    testWidgets('SplashScreen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SplashScreen(),
          theme: ThemeData(
            primaryColor: const Color(0xFF429690), // Example primary color
          ),
        ),
      );

      expect(find.byType(SplashScreen), findsOneWidget);

      expect(find.text('Spend Smarter, Save More'), findsOneWidget);
    });
  });
}
