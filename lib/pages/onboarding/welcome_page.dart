import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          const SizedBox(),
          Text(
            'Welcome to Chess Trainer',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return FilledButton(
                    onPressed: () {},
                    child: const Text('Get Started'),
                  );
                },
              ),
              OutlinedButton(
                child: const Text('I already have an account'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
