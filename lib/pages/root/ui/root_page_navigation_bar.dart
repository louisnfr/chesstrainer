import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RootPageNavigationBar extends StatefulWidget {
  const RootPageNavigationBar({
    super.key,
    required this.onDestinationSelected,
    required this.selectedIndex,
    required this.pages,
  });

  final void Function(int) onDestinationSelected;
  final int selectedIndex;
  final List<Widget> pages;

  @override
  State<RootPageNavigationBar> createState() => _RootPageNavigationBarState();
}

class _RootPageNavigationBarState extends State<RootPageNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 50,
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onDestinationSelected,
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
        // NavigationDestination(
        //   icon: Icon(
        //     Icons.explore_outlined,
        //     color: Theme.of(context).colorScheme.outline,
        //     size: 30,
        //   ),
        //   selectedIcon: const Icon(
        //     Icons.explore,
        //     color: Colors.green,
        //     size: 30,
        //   ),
        //   label: 'Explorer',
        // ),
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
    );
  }
}
