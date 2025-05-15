import 'package:easy_hire/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'core/app_router.dart';
import 'core/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      routerConfig: AppRouter.router,
    );
  }
}