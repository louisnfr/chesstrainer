import 'package:chesstrainer/pages/auth/login_page.dart';
import 'package:chesstrainer/pages/auth/register_page.dart';
import 'package:chesstrainer/pages/home/home_page.dart';
import 'package:chesstrainer/pages/profile/profile_page.dart';
import 'package:chesstrainer/pages/root/shell_page.dart';
import 'package:go_router/go_router.dart';

class RoutePaths {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
}

final appRoutes = <RouteBase>[
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ShellPage(navigationShell: navigationShell);
    },
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.home,
            builder: (context, state) => const HomePage(),
            routes: [
              // GoRoute(
              //   path: 'openings/:openingName',
              //   builder: (context, state) {
              //     final openingId = state.pathParameters['openingId'];
              //     return OpeningPage(opening: opening);
              //   },
              // ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePaths.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  ),

  // Shell route avec navigation bar
  // ShellRoute(
  //   builder: (context, state, child) => Scaffold(
  //     body: SafeArea(child: child),
  //     bottomNavigationBar: NavigationBar(
  //       height: 48,
  //       destinations: [
  //         const NavigationDestination(
  //           icon: Icon(Icons.home_rounded),
  //           selectedIcon: Icon(Icons.home),
  //           label: 'Home',
  //         ),
  //         const NavigationDestination(
  //           icon: Icon(Icons.account_circle_outlined),
  //           selectedIcon: Icon(Icons.account_circle),
  //           label: 'Profile',
  //         ),
  //       ],
  //     ),
  //   ),
  //   routes: [
  //     GoRoute(
  //       path: RoutePaths.home,
  //       builder: (context, state) => const HomePage(),
  //     ),
  //     GoRoute(
  //       path: RoutePaths.profile,
  //       builder: (context, state) => const ProfilePage(),
  //     ),
  //   ],
  // ),

  // Routes d'authentification (hors shell)
  GoRoute(
    path: RoutePaths.login,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: RoutePaths.register,
    builder: (context, state) => const RegisterPage(),
  ),
];
