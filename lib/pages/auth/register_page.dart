import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/ui/buttons/primary_button.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body: PageLayout(
        child: Column(
          children: [
            Column(
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
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authNotifierProvider);

                    ref.listen(authNotifierProvider, (previous, next) {
                      if (previous?.isLoading == true && next.hasValue) {
                        Navigator.pop(context);
                      }
                    });

                    if (authState.isLoading) {
                      return const CircularProgressIndicator();
                    }

                    return Column(
                      children: [
                        PrimaryButton(
                          onPressed: () async {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                          },
                          text: 'Register',
                        ),
                        if (authState.hasError)
                          Text(
                            'Error: ${authState.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
