import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:easy_hire/features/home/view/home_screen.dart';
import 'package:easy_hire/features/job_apply/view/job_apply_screen.dart';
import 'package:easy_hire/features/job_status/view/job_status_screen.dart';
import 'package:easy_hire/features/job_search/view/job_search_screen.dart';
import 'package:easy_hire/features/settings/view/settings_screen.dart';
import 'package:easy_hire/core/widgets/bottom_nav.dart';
import 'package:easy_hire/features/job_detail/view/job_detail_screen.dart';
import 'package:easy_hire/features/profile/view/profile_screen.dart';
import 'package:easy_hire/features/Log_in/login.dart';
import 'package:easy_hire/core/models/job_model.dart';

/// ✅ Create a GoRouter provider
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(googleAuthProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
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
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const BottomNav(
          selectedIndex: 3,
          child: SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/job-detail',
        builder: (context, state) {
          final job = state.extra as JobModel;
          return JobDetailScreen(job: job);
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
});
