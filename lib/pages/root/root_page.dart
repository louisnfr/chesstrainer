import 'package:chesstrainer/pages/home/home_page.dart';
import 'package:chesstrainer/pages/profile/profile_page.dart';
import 'package:chesstrainer/pages/root/ui/root_page_navigation_bar.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    // const Text('Explorer Page'),
    const ProfilePage(),
  ];

  void onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RootPageNavigationBar(
        onDestinationSelected: onDestinationSelected,
        selectedIndex: selectedIndex,
        pages: pages,
      ),
      body: IndexedStack(index: selectedIndex, children: pages),
    );
  }
}
