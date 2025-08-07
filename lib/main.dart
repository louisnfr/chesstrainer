import 'package:chesstrainer/firebase_options.dart';
import 'package:chesstrainer/modules/router/router_provider.dart';
import 'package:chesstrainer/ui/theme/dark_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Chess Trainer',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      routerConfig: router,
    );
  }
}
