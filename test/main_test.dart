import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/pages/intro_page.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:expense_tracker/pages/main_page.dart';
import 'package:expense_tracker/pages/signup_page.dart';
import 'package:expense_tracker/screens/income_list_screen.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'mock.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  setupFirebaseAuthMocks();
  late MockGoogleSignIn googleSignIn;

  setUpAll(() async {
    await Firebase.initializeApp();
    googleSignIn = MockGoogleSignIn();
  });

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
      await tester.runAsync(
        () => tester.pumpWidget(
          MaterialApp(home: ExpenseTracker(firebaseAuth: fakeAuth)),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('User sees IntroPage on first open',
        (WidgetTester tester) async {
      final mockUser = MockUser(isAnonymous: false, uid: 'someuid');
      final fakeAuth = MockFirebaseAuth(mockUser: mockUser);

      await tester.runAsync(
        () => tester.pumpWidget(
          MaterialApp(home: ExpenseTracker(firebaseAuth: fakeAuth)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 3));

      // Verify that MainPage is shown for authenticated user
      expect(find.byType(IntroPage), findsOneWidget);
    });
  });

  group('ExpenseTracker Tests', () {
    late MockFirestoreService mockFirestoreService;
    late MockUser mockUser;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      SharedPreferences.setMockInitialValues({'first_time': false});
      mockFirestoreService = MockFirestoreService();
    });

    testWidgets('Authenticated user sees MainPage',
        (WidgetTester tester) async {
      // create a mock authenticated user
      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'someuid',
        email: 'test@gmail.com',
        displayName: 'Test User',
      );

      final fakeAuth = MockFirebaseAuth(mockUser: mockUser);
      final mockGoogleSignIn = MockGoogleSignIn();

      // replace the FirebaseAuth instance with the fake in your app
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

      // await tester.tap(find.text('Continue with Google'));
      // await tester.pumpAndSettle();

      // Tap the Google Sign-In button
      final googleSignInButtonFinder = find.byKey(const ValueKey('google'));
      await tester.tap(googleSignInButtonFinder);
      await tester.pumpAndSettle();

      // Verify that MainPage is shown for authenticated user

      for (var widget in tester.allWidgets) {
        print(widget);
      }

      expect(find.byType(MainPage), findsOneWidget);
      // verify that MainPage is shown for authenticated user
      // expect(find.byType(MainPage), findsOneWidget);
    });
  });
}
