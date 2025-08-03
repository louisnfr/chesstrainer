import 'package:flutter/material.dart';

class PageLayout extends StatelessWidget {
  final Widget child;

  const PageLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}
