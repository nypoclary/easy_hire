import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const BottomNav({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  static const tabs = ['/', '/job-search', '/job-status', '/settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.indigo[700],
          backgroundColor: const Color(0x33A2CEF4),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) => IconThemeData(
              color:
                  states.contains(WidgetState.selected)
                      ? Colors.white
                      : Colors.black87,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            context.go(tabs[index]);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              label: 'Status',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
