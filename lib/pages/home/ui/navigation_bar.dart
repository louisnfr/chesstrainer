import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 0,
          ),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceDim,
          indicatorColor: Colors.transparent,
          height: 48,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.school_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
              selectedIcon: Icon(
                Icons.school,
                color: Theme.of(context).colorScheme.primary,
                fill: 1,
              ),
              label: 'Learn',
            ),
            NavigationDestination(
              icon: Icon(
                Symbols.target,
                color: Theme.of(context).colorScheme.outline,
              ),
              selectedIcon: const Icon(
                Symbols.target,
                color: Colors.green,
                weight: 700,
              ),
              label: 'Practice',
            ),
            NavigationDestination(
              icon: Icon(
                Symbols.trophy,
                color: Theme.of(context).colorScheme.outline,
              ),
              selectedIcon: const Icon(
                Symbols.trophy,
                color: Colors.orange,
                fill: 1,
              ),
              label: 'Leaderboard',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.account_circle_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
              selectedIcon: const Icon(
                Icons.account_circle,
                color: Colors.deepPurpleAccent,
              ),

              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
