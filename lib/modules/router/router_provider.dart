import 'dart:async';

import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helper class pour refresh GoRouter quand authState change
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Router provider avec refresh automatique
final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: RoutePaths.login,
    routes: appRoutes,
    refreshListenable: GoRouterRefreshStream(authService.authStateChanges()),
    redirect: (context, state) {
      final user = authService.currentUser;
      final isLoggedIn = user != null;

      final isOnAuthPage =
          state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register;

      if (isLoggedIn && isOnAuthPage) {
        return RoutePaths.home;
      }

      if (!isLoggedIn && !isOnAuthPage) {
        return RoutePaths.login;
      }

      return null;
    },

    // Page d'erreur custom
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
