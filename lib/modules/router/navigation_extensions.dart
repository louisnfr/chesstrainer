import 'package:chesstrainer/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Extension utile pour la navigation
extension AppNavigation on BuildContext {
  // Navigation simple vers les routes principales
  void goToHome() => go(AppRoutes.home);
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToProfile() => go(AppRoutes.profile);
  void goToWelcome() => go(AppRoutes.welcome);
  void goToOnboarding() => go(AppRoutes.onboarding);

  // Helper pour retourner en arrière si possible, sinon aller au login
  void goBackOrLogin() {
    if (canPop()) {
      pop();
    } else {
      goToLogin();
    }
  }
}
