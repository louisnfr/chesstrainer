import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/pages/auth/login_page.dart';
import 'package:chesstrainer/pages/auth/register_page.dart';
import 'package:chesstrainer/pages/learn/learn_page.dart';
import 'package:chesstrainer/pages/opening/opening_page.dart';
import 'package:chesstrainer/pages/openings/openings_page.dart';
import 'package:chesstrainer/pages/profile/profile_page.dart';
import 'package:chesstrainer/pages/root/shell_page.dart';
import 'package:go_router/go_router.dart';

class Routes {
  // * Auth routes
  static const String login = '/login';
  static const String register = '/register';

  // * Openings routes
  static const String openings = '/openings';
  static const String openingDetail = ':openingName';

  // * Profile routes
  static const String profile = '/profile';

  // * Learn routes
  static const String learn = '/learn';

  // * Practice routes
  static const String practice = '/practice';
}

final appRoutes = <RouteBase>[
  // * Auth routes
  GoRoute(path: Routes.login, builder: (context, state) => const LoginPage()),
  GoRoute(
    path: Routes.register,
    builder: (context, state) => const RegisterPage(),
  ),

  // * Main shell route
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ShellPage(navigationShell: navigationShell);
    },
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.openings,
            builder: (context, state) => const OpeningsPage(),
            routes: [
              GoRoute(
                path: Routes.openingDetail,
                builder: (context, state) {
                  return OpeningPage(opening: state.extra as OpeningModel);
                },
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  ),

  // * Learn routes
  GoRoute(
    path: Routes.learn,
    builder: (context, state) {
      return LearnPage(opening: state.extra as OpeningModel);
    },
  ),

  // * Practice routes
  GoRoute(
    path: Routes.practice,
    builder: (context, state) {
      return LearnPage(opening: state.extra as OpeningModel);
    },
  ),
];
