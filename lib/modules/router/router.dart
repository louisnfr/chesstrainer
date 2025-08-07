import 'dart:async';

import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/services/auth_service.dart';
import 'package:chesstrainer/pages/auth/login_page.dart';
import 'package:chesstrainer/pages/auth/register_page.dart';
import 'package:chesstrainer/pages/onboarding/onboarding_page.dart';
import 'package:chesstrainer/pages/onboarding/welcome_page.dart';
import 'package:chesstrainer/pages/profile/profile_page.dart';
import 'package:chesstrainer/pages/root/root_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider local pour auth service
final _authServiceProvider = Provider<AuthService>((ref) => AuthService());

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
  final authService = ref.read(_authServiceProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(authService.authStateChanges()),
    redirect: (context, state) {
      // Obtenir l'état d'auth actuel directement depuis le service
      final user = authService.currentUser;
      final isLoggedIn = user != null;

      final isOnAuthPage =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Si connecté mais sur une page d'auth, rediriger vers home
      if (isLoggedIn && isOnAuthPage) {
        return AppRoutes.home;
      }

      // Si pas connecté mais pas sur une page d'auth, rediriger vers login
      if (!isLoggedIn && !isOnAuthPage) {
        return AppRoutes.login;
      }

      // Sinon, laisser la navigation normale
      return null;
    },
    routes: [
      // Route principale (home avec navigation)
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const RootPage(),
      ),

      // Routes d'authentification
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // Routes d'onboarding
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const Onboarding(),
      ),

      // Route profile (si besoin d'accès direct)
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
    ],

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
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Helper pour obtenir le router dans les widgets
extension GoRouterExtension on WidgetRef {
  GoRouter get router => read(routerProvider);
}
