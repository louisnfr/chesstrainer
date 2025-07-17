import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/services/auth_service.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(title: const Text('Onboarding')),
      child: FutureBuilder(
        future: AuthService.signInAnonymously(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasError) {
            return Center(child: Text('Error: ${asyncSnapshot.error}'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    homeRoute,
                    (_) => false,
                  );
                },
                child: const Text('Finish onboarding'),
              ),
            ],
          );
        },
      ),
    );
  }
}
