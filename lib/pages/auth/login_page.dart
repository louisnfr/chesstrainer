import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/ui/buttons/primary_button.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in')),
      body: PageLayout(
        child: Column(
          spacing: 12,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
            ),
            Consumer(
              builder: (context, ref, child) {
                return PrimaryButton(
                  onPressed: () async {
                    await ref
                        .read(authNotifierProvider.notifier)
                        .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                  },
                  text: 'Log in',
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  registerRoute,
                  // (route) => route.isFirst,
                );
              },
              child: const Text("Don't have an account yet? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
