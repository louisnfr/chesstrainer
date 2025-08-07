import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/ui/buttons/primary_button.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:chesstrainer/ui/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                final loginState = ref.watch(loginNotifierProvider);

                if (loginState.isLoading) {
                  return const CircularProgressIndicator();
                }

                return Column(
                  spacing: 12,
                  children: [
                    PrimaryButton(
                      onPressed: () async {
                        await ref
                            .read(loginNotifierProvider.notifier)
                            .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                      },
                      text: 'Log in',
                    ),
                    if (loginState.hasError)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Login failed: ${loginState.error}',
                                style: const TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
            TextButton(
              onPressed: () {
                context.push(AppRoutes.register);
              },
              child: const Text("Don't have an account yet? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
