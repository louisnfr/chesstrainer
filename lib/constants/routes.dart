import 'package:chesstrainer/pages/auth/login_page.dart';
import 'package:chesstrainer/pages/auth/register_page.dart';
import 'package:chesstrainer/pages/profile/profile_page.dart';
import 'package:chesstrainer/pages/root/root_page.dart';
import 'package:go_router/go_router.dart';

class RoutePaths {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
}

final appRoutes = <RouteBase>[
  GoRoute(path: RoutePaths.home, builder: (context, state) => const RootPage()),

  // Routes d'authentification
  GoRoute(
    path: RoutePaths.login,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: RoutePaths.register,
    builder: (context, state) => const RegisterPage(),
  ),

  // Route profile (si besoin d'accès direct)
  GoRoute(
    path: RoutePaths.profile,
    builder: (context, state) => const ProfilePage(),
  ),
];
