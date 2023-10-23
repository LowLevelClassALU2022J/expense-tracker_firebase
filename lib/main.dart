import 'package:expense_tracker/pages/signup_page.dart';
import 'package:expense_tracker/screens/expense_categories_list.dart';
import 'package:expense_tracker/screens/expense_list.dart';
import 'package:expense_tracker/screens/income_categories_list.dart';
import 'package:expense_tracker/screens/income_list_screen.dart';
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
  runApp(const ExpenseTracker());
}

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  Future<bool> checkFirstOpen() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate a delay
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;
    if (isFirstTime) {
      await prefs.setBool('first_time', false);
    }
    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primaryColor: const Color(0xFF429690),
      ),
      home: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return const MainPage(); // If the user is already authenticated.
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
        '/main': (context) => const MainPage(),
        '/splash': (context) => const SplashScreen(),
        '/incomeList': (context) => const IncomeListScreen(),
        '/incomeCategoryList': (context) => EditIncomeCategoryScreen(),
        '/expenseList': (context) => const ExpenseListScreen(),
        '/expenseCategoryList': (context) => EditExpenseCategoryScreen(),
      },
    );
  }
}
