import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/ui/buttons/outline_button.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: PageLayout(
        child: Column(
          children: [
            Text(
              'User Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Consumer(
              builder: (context, ref, child) {
                return OutlineButton(
                  onPressed: () {
                    final auth = ref.read(authNotifierProvider.notifier);
                    auth.signOut();
                  },
                  text: 'log out',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
