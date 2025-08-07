import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/ui/buttons/secondary_button.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    final joinedDate = user?.createdAt != null
        ? DateFormat('MMMM yyyy').format(user!.createdAt)
        : 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_rounded,
              color: theme.colorScheme.outline,
              size: 32,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: PageLayout(
        child: Column(
          children: [
            Text(user?.displayName ?? 'No user logged in'),
            Text('Joined $joinedDate'),
            SecondaryButton(
              onPressed: () {
                final auth = ref.read(authNotifierProvider.notifier);
                auth.signOut();
              },
              text: 'Log out',
            ),
          ],
        ),
      ),
    );
  }
}
