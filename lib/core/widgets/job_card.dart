import 'package:flutter/material.dart';
import 'package:easy_hire/core/models/job_model.dart';
import 'package:easy_hire/core/models/user_service.dart';
import 'package:easy_hire/features/profile/view/profile_screen.dart';

class JobCardWidget extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCardWidget({
    super.key,
    required this.job,
    required this.onTap,
  });

  void _handleProfileTap(BuildContext context) async {
    if (job.createdBy == null || job.createdBy!.trim().isEmpty) return;
    try {
      final user = await fetchUserById(job.createdBy!);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load profile.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDAD0FF), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _handleProfileTap(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE8FF),
                      shape: BoxShape.circle,
                    ),
                    child: job.createdByPhotoUrl != null && job.createdByPhotoUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              job.createdByPhotoUrl!,
                              fit: BoxFit.cover,
                              width: 44,
                              height: 44,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person),
                            ),
                          )
                        : const Icon(Icons.person, size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.role,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2A1258),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${job.company}, ${job.location}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: job.salary,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9333EA),
                ),
                children: const [
                  TextSpan(
                    text: '/Mo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTag(job.category, const Color(0xFFF3F0FF), const Color(0xFF5B2E91)),
                const SizedBox(width: 8),
                _buildWorkModeTag(job.workMode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildWorkModeTag(String label) {
    final lower = label.toLowerCase();
    Color bgColor;
    Color textColor;

    if (lower.contains('remote')) {
      bgColor = const Color(0xFFFFE4D6);
      textColor = const Color(0xFFDE6E35);
    } else if (lower.contains('full')) {
      bgColor = const Color(0xFFD6E9FF);
      textColor = const Color(0xFF1C6DB2);
    } else if (lower.contains('part')) {
      bgColor = const Color(0xFFD6F5E8);
      textColor = const Color(0xFF1C8B5F);
    } else {
      bgColor = const Color(0xFFEAEAEA);
      textColor = Colors.black87;
    }

    return _buildTag(label, bgColor, textColor);
  }
}
