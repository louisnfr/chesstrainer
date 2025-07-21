import 'package:chesstrainer/modules/auth/services/auth_service.dart';
import 'package:chesstrainer/modules/user/services/user_service.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      child: Center(
        child: Column(
          children: [
            Column(
              spacing: 8,
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
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     await AuthService.linkWithCredential(
                //       email: _emailController.text,
                //       password: _passwordController.text,
                //     );
                //     await UserService.upgradeAnonymousUser(
                //       email: _emailController.text,
                //     );
                //     if (context.mounted) Navigator.pop(context);
                //   },
                //   child: const Text('Register'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
