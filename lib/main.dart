import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/firebase_options.dart';
import 'package:chesstrainer/pages/auth/login_page.dart';
import 'package:chesstrainer/pages/auth/register_page.dart';
import 'package:chesstrainer/pages/home/home_page.dart';
import 'package:chesstrainer/pages/learn/learn_page.dart';
import 'package:chesstrainer/pages/onboarding/onboarding_page.dart';
import 'package:chesstrainer/pages/onboarding/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const WelcomePage(),
      routes: {
        welcomeRoute: (context) => const WelcomePage(),
        onboardingRoute: (context) => const Onboarding(),
        loginRoute: (context) => const LoginPage(),
        homeRoute: (context) => const HomePage(),
        learnRoute: (context) => const LearnPage(),
        registerRoute: (context) => const RegisterPage(),
      },
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
