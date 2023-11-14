import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: const Color(0xFF429690),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (password == confirmPassword) {
                    final user = await signUpWithEmail(email, password);
                    if (user != null) {
                      // Optionally navigate to another screen or show a success message
                    } else {
                      print('Error during email signup');
                    }
                  } else {
                    print('Passwords do not match');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                ),
                child: const Text('Signup'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                ),
                onPressed: () async {
                  final user = await signInWithGoogle();
                  if (user != null) {
                    // Optionally navigate to another screen or show a success message
                  } else {
                    print('Error during Google Sign In');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Ensure the user is not anonymous
          assert(!user.isAnonymous);
          // Ensure the user is the current user
          assert(user.uid == _auth.currentUser!.uid);

          print('Google Sign In succeeded: $user');
          // navigate to another /main screen
          Navigator.of(context).pushReplacementNamed('/main');

          return user;
        }
      }
    } catch (error) {
      print(error);
      return null;
    }
    return null;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = authResult.user;

      if (user != null) {
        // Ensure the user is not anonymous
        assert(!user.isAnonymous);
        // Ensure the user is the current user
        assert(user.uid == _auth.currentUser!.uid);

        print('Email Sign Up succeeded: $user');
        return user;
      }
    } catch (error) {
      print(error);
      return null;
    }
    return null;
  }
}
