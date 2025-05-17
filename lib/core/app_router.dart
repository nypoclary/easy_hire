import 'package:easy_hire/features/home/view/home_screen.dart';
import 'package:easy_hire/features/job_status/view/job_status_screen.dart';
import 'package:easy_hire/features/job_search/view/job_search_screen.dart';
import 'package:easy_hire/features/settings/view/settings_screen.dart';
import 'package:easy_hire/core/widgets/bottom_nav.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/home',
    //errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
          builder: (context, state) => const BottomNav(
            selectedIndex: 0,
            child: HomeScreen(),
          ),
      ),
      GoRoute(
        path: '/search',
        name: 'jobSearch',
        builder: (context, state) => const BottomNav(
          selectedIndex: 1,
          child: JobSearchScreen(),
        ),
      ),
      GoRoute(
        path: '/status',
        name: 'jobStatus',
        builder: (context, state) => const BottomNav(
          selectedIndex: 2,
          child: JobStatusScreen(),
        ),
      ),
      GoRoute(path: '/settings',
        name: 'settings',
        builder: (context, state) => const BottomNav(
          selectedIndex: 3,
          child: SettingsScreen(),
        ),
      ),
    ],
  );
}