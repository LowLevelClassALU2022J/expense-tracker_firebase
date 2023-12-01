import 'package:expense_tracker/pages/signup_page.dart';
import 'package:expense_tracker/screens/expense_categories_list.dart';
import 'package:expense_tracker/screens/expense_list.dart';
import 'package:expense_tracker/screens/income_categories_list.dart';
import 'package:expense_tracker/screens/income_list_screen.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/pages/main_page.dart';
import 'package:expense_tracker/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/pages/intro_page.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ExpenseTracker());
}

class ExpenseTracker extends StatefulWidget {
  final FirebaseAuth auth;
  final FirestoreService firestoreService;

  ExpenseTracker(
      {Key? key,
      FirebaseAuth? firebaseAuth,
      FirestoreService? firestoreService})
      : auth = firebaseAuth ?? FirebaseAuth.instance,
        firestoreService = firestoreService ??
            FirestoreService(FirebaseAuth.instance.currentUser!.uid),
        super(key: key);

  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  late Future<bool> isFirstOpen;
  bool _isDisposed = false; // Flag to track if the widget is disposed

  @override
  void initState() {
    super.initState();
    isFirstOpen = checkFirstOpen();
  }

  Future<bool> checkFirstOpen() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // simulate a delay

      if (_isDisposed) {
        return false; // Return default value if the widget is disposed
      }

      final prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('first_time') ?? true;
      if (isFirstTime) {
        await prefs.setBool('first_time', false);
      }
      return isFirstTime;
    } catch (e) {
      // Handle any exceptions here
      return false; // Return default value in case of an error
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // Set the flag to true when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primaryColor: const Color(0xFF429690),
      ),
      home: StreamBuilder(
        stream: widget.auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return MainPage(
                firebaseAuth: widget.auth,
                firestoreService: widget.firestoreService,
              ); // If the user is already authenticated.
            } else {
              return FutureBuilder<bool>(
                future: checkFirstOpen(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  } else {
                    return snapshot.data == true
                        ? const IntroPage()
                        : const LoginPage();
                  }
                },
              );
            }
          }
          return const SplashScreen();
        },
      ),
      routes: {
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/intro': (context) => const IntroPage(),
        '/main': (context) => MainPage(
            firebaseAuth: widget.auth,
            firestoreService: widget.firestoreService),
        '/splash': (context) => const SplashScreen(),
        '/incomeList': (context) => IncomeListScreen(
              firestoreService: widget.firestoreService,
            ),
        '/incomeCategoryList': (context) =>
            EditIncomeCategoryScreen(firestoreService: widget.firestoreService),
        '/expenseList': (context) =>
            ExpenseListScreen(firestoreService: widget.firestoreService),
        '/expenseCategoryList': (context) => EditExpenseCategoryScreen(
            firestoreService: widget.firestoreService),
      },
    );
  }
}
