import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/ui/buttons/primary_button.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
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
    return DefaultLayout(
      appBar: AppBar(title: const Text('Login')),
      child: Column(
        spacing: 12,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(hint: Text('Email')),
            autocorrect: false,
            enableSuggestions: false,
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hint: Text('Password')),
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
                text: 'Login',
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Don't have an account yet? Register"),
          ),
        ],
      ),
    );
  }
}
