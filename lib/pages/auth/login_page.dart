import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/user/providers/user_provider.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/foundation.dart';
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
              return TextButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(userNotifierProvider.notifier)
                        .login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                    if (context.mounted) {
                      Navigator.pushNamed(context, homeRoute);
                    }
                  } catch (e) {
                    if (kDebugMode) print('Error on login: $e');
                  }
                },
                child: const Text('Login'),
              );
            },
          ),
        ],
      ),
    );
  }
}
