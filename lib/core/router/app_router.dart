import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/screen_one/presentation/pages/screen_one_page.dart';
import '../../features/screen_two/presentation/pages/screen_two_page.dart';
import '../../features/screen_three/presentation/pages/screen_three_page.dart';
import '../layout/main_shell_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainShellPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/screen1',
          builder: (context, state) => const ScreenOnePage(),
        ),
        GoRoute(
          path: '/screen2',
          builder: (context, state) => const ScreenTwoPage(),
        ),
        GoRoute(
          path: '/screen3',
          builder: (context, state) => const ScreenThreePage(),
        ),
      ],
    ),
  ],
);
