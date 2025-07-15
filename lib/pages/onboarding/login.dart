import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Chess Trainer',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
              ),
              Column(
                spacing: 8,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Try without account',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {},
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 64),
                    child: Divider(),
                  ),

                  Column(
                    children: [
                      ElevatedButton(
                        child: const Text('Sign in with Google'),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        child: const Text('Sign in with Apple'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 0,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Already have an account?'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Log in',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
