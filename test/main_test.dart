import 'package:expense_tracker/main.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Main App Tests', () {
    setUp(() {
      // Initialize SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Correct home widget is displayed based on auth state',
        (WidgetTester tester) async {
      // Create a mock user
      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'someuid',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      // Create a fake FirebaseAuth instance using the mock user
      final fakeAuth = MockFirebaseAuth(mockUser: mockUser);

      // Replace the FirebaseAuth instance with the fake in your app
      await tester.pumpWidget(
          MaterialApp(home: ExpenseTracker(firebaseAuth: fakeAuth)));
      await tester.pump(const Duration(seconds: 3));
      // Waits for all animations and timers to complete
      await tester.pumpAndSettle();

      // End

      // Add your assertions here
      // For example, check if MainPage is displayed for authenticated users
      // expect(find.byType(MainPage), findsOneWidget);
    });
  });
}
