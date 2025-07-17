import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';

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
          TextButton(onPressed: () {}, child: const Text('Login')),
        ],
      ),
    );
  }
}
