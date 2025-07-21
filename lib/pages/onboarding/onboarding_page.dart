import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(leading: null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 12,
        children: [
          const Column(
            spacing: 12,
            children: [
              Text(
                'Welcome to Chess Trainer! '
                'Just 2 quick questions before we start playing.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'What is your chess skill level?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return FilledButton(
                    onPressed: () async {
                      await ref
                          .read(authNotifierProvider.notifier)
                          .signInAnonymously();
                    },
                    child: const Text('Finish Onboarding'),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
