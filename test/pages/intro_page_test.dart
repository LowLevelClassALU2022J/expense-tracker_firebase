import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/pages/intro_page.dart';

void main() {
  group('IntroPage Tests', () {
    testWidgets('Components are correctly displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: IntroPage(),
        ),
      );

      // Check for the presence of the image
      expect(find.byType(Image), findsOneWidget);

      // Check for the main text
      expect(find.text('Spend Smarter, Save More'), findsOneWidget);

      // Check for the 'Get Started' button
      expect(
          find.widgetWithText(ElevatedButton, 'Get Started'), findsOneWidget);

      // Check for the 'Already have an account? Log In' button
      expect(find.widgetWithText(TextButton, 'Already have an account? Log In'),
          findsOneWidget);
    });
  });
}
