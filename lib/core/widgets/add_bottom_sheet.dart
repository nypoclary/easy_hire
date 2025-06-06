import 'package:flutter/material.dart';
import 'package:easy_hire/core/app_theme.dart';
import 'package:go_router/go_router.dart';

class AddBottomSheet extends StatelessWidget {
  const AddBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        border: Border.all(color: AppTheme.primaryNavyBlue, width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryNavyBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const Text(
            'Job Type',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Are you looking for a job or hire an employee?',
            style: TextStyle(fontSize: 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Find A Job Button
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                context.go('/job-search');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryNavyBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Find A Job',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Create A Job Button
          SizedBox(
            width: 300,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();       // Close the bottom sheet
                Future.microtask(() =>             // Avoid push from closing context
                  context.push('/create-job'),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Create A Job',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
