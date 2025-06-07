import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobFilterOptions extends StatelessWidget {
  const JobFilterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Remote Job (Tall Card)
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 260,
              child: _buildJobCategoryCard(
                context,
                title: 'Remote Job',
                imagePath: 'assets/images/remote.png',
                color: const Color(0xFFFABFBC),
                borderColor: const Color(0xFFA2CEF4),
                onTap: () {
                  context.go('/job-search/remote'); // ✅ normalized
                },
              ),
            ),
          ),
          const SizedBox(width: 16.0),

          // Right: Part Time + Full Time
          Expanded(
            flex: 1,
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: _buildJobCategoryCard(
                    context,
                    title: 'Part Time',
                    imagePath: 'assets/images/part_time.png',
                    color: const Color(0xFFE2F8D5),
                    borderColor: const Color(0xFFCBF4A2).withOpacity(0.5),
                    onTap: () {
                      context.go('/job-search/part time'); // ✅ normalized
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: _buildJobCategoryCard(
                    context,
                    title: 'Full Time',
                    imagePath: 'assets/images/full_time.png',
                    color: const Color(0xFFB5E2FA),
                    borderColor: const Color(0xFF7FC3FF).withOpacity(0.5),
                    onTap: () {
                      context.go('/job-search/full time'); // ✅ normalized
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCategoryCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: borderColor, width: 2.0),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
