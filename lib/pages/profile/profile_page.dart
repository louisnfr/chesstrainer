import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:flutter/material.dart';

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
            onPressed: () {
              // Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: PageLayout(
        child: Text(
          'User Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
