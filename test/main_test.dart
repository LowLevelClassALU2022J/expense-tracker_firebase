import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';

import 'mock.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('ExpenseTracker Tests', () {
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      SharedPreferences.setMockInitialValues({'first_time': false});
      mockFirestoreService = MockFirestoreService();
    });

    testWidgets('User sees LoginPage', (WidgetTester tester) async {
      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'someuid',
        email: 'test@gmail.com',
        displayName: 'Test User',
      );

      final fakeAuth = MockFirebaseAuth(mockUser: mockUser);

      await tester.runAsync(
        () => tester.pumpWidget(
          MaterialApp(
              home: ExpenseTracker(
            firebaseAuth: fakeAuth,
            firestoreService: mockFirestoreService,
          )),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 3));

      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
