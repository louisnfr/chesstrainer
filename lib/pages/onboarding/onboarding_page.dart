import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

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
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Enter your username',
              border: OutlineInputBorder(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final authState = ref.watch(authNotifierProvider);

                  return authState.when(
                    data: (_) => FilledButton(
                      onPressed: () async {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInAnonymously();

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Finish Onboarding'),
                    ),
                    loading: () => const FilledButton(
                      onPressed: null,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                    error: (error, stack) => FilledButton(
                      onPressed: () async {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInAnonymously();
                      },
                      child: const Text('Retry'),
                    ),
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
