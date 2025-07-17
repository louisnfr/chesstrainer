import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(title: const Text('Welcome Page')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          ElevatedButton(
            child: const Text('Get Started'),
            onPressed: () {
              Navigator.pushNamed(context, onboardingRoute);
            },
          ),
          OutlinedButton(
            child: const Text('I already have an account'),
            onPressed: () {
              Navigator.pushNamed(context, loginRoute);
            },
          ),
        ],
      ),
    );
  }
}
