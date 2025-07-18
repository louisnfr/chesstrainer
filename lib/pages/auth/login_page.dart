import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/user/providers/user_provider.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
          TextButton(
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
          ),
        ],
      ),
    );
  }
}
