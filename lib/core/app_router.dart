import 'package:easy_hire/features/home/view/home_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    //errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}