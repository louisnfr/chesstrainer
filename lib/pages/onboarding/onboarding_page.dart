import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/user/providers/user_provider.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Onboarding extends ConsumerStatefulWidget {
  const Onboarding({super.key});

  @override
  ConsumerState<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends ConsumerState<Onboarding> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(title: const Text('Onboarding')),
      child: FutureBuilder(
        future: ref.read(userNotifierProvider.notifier).signInAnonymously(),
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        if (value.length > 15) {
                          return 'Username must be less than 15 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final username = _usernameController.text;

                      // Utiliser le provider pour créer l'utilisateur
                      await ref
                          .read(userNotifierProvider.notifier)
                          .createUser(username);

                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          homeRoute,
                          (_) => false,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  }
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
