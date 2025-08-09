import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: PageLayout(
        child: ListView(
          children: [
            _buildSection(context, 'Support', [
              _buildItem(
                context,
                Icons.feedback_outlined,
                'Feedback',
                () => print('Feedback'),
              ),
            ]),
            const SizedBox(height: 20),

            _buildSection(context, 'Legal', [
              _buildItem(
                context,
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                () => print('Privacy Policy'),
              ),
              _buildItem(
                context,
                Icons.article_outlined,
                'Terms of Service',
                () => print('Help & Support'),
              ),
            ]),

            const SizedBox(height: 20),

            _buildSection(context, 'Security', [
              _buildItem(context, Icons.logout_outlined, 'Log out', () {
                ref.read(authNotifierProvider.notifier).signOut();
              }),
              _buildItem(
                context,
                Icons.delete_outline,
                'Delete account',
                () => print('Delete account'),
                Colors.red,
              ),
            ]),
            const SizedBox(height: 20),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Text(
                      'Version ${snapshot.data!.version}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink(); // Loading state
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String header,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            header,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: items.map((item) {
                final isLast = items.last == item;
                return Container(
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.2),
                              width: 0.5,
                            ),
                          ),
                  ),
                  child: item,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, [
    Color? textColor,
  ]) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceDim,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: textColor ?? Theme.of(context).iconTheme.color,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        textColor ??
                        Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
