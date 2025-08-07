import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 50,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: [
          NavigationDestination(
            icon: Icon(
              Symbols.home_rounded,
              color: Theme.of(context).colorScheme.outline,
              size: 30,
            ),
            selectedIcon: Icon(
              Symbols.home_rounded,
              color: Theme.of(context).colorScheme.primary,
              fill: 1,
              size: 30,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Theme.of(context).colorScheme.outline,
              size: 30,
            ),
            selectedIcon: const Icon(
              Icons.account_circle_sharp,
              color: Colors.white,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
