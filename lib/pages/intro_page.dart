import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/intro.png'),
          Text(
            'Spend Smarter, Save More',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/main'); // Navigate to main screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Get Started'),
          ),
          // add some space
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/login'); // Navigate to login screen
            },
            // text should be the primary color
            style:
                TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            child: const Text('Already have an account? Log In'),
          ),
        ],
      ),
    );
  }
}
