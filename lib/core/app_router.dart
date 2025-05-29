import 'package:easy_hire/features/home/view/home_screen.dart';
import 'package:easy_hire/features/job_apply/view/job_apply_screen.dart';
import 'package:easy_hire/features/job_status/view/job_status_screen.dart';
import 'package:easy_hire/features/job_search/view/job_search_screen.dart';
import 'package:easy_hire/features/settings/view/settings_screen.dart';
import 'package:easy_hire/core/widgets/bottom_nav.dart';
import 'package:easy_hire/features/job_detail/view/job_detail_screen.dart';
import 'package:easy_hire/features/profile/view/profile_screen.dart';

import 'package:go_router/go_router.dart';
class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    //errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
          builder: (context, state) => const BottomNav(
            selectedIndex: 0,
            child: HomeScreen(),
          ),
      ),
      GoRoute(
        path: '/job-search',
        name: 'jobSearch',
        builder: (context, state) => const BottomNav(
          selectedIndex: 1,
          child: JobSearchScreen(category: null),
        ),
        routes: [
          // Make this a sub-route of /job-search
          GoRoute(
            path: ':category',
            builder: (context, state) {
              final category = state.pathParameters['category']!;
              return JobSearchScreen(category: category);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/job-status',
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
      GoRoute(
        path: '/job-detail',
        builder: (context, state) {
          return const JobDetailScreen(
            role: 'Default Role',
            company: 'Default Company',
            salary: '\$0',
            tags: [],
            requirements: '',
            responsibilities: '',
            jobSummary: {},
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/apply-job',
        builder: (context, state) => const JobApplyScreen(),
      ),
    ],
  );
}