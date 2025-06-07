import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/core/models/job_model.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/app_theme.dart';
import 'package:easy_hire/features/profile/view/profile_screen.dart';
import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:easy_hire/core/models/user_service.dart';

class JobDetailScreen extends ConsumerWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(googleAuthProvider).value;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const BackButton(color: Colors.black),
                  const Spacer(),
                  Text(
                    'Job Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _handleProfileTap(context),
                    child: CircleAvatar(
                      backgroundImage: job.createdByPhotoUrl != null &&
                              job.createdByPhotoUrl!.isNotEmpty
                          ? NetworkImage(job.createdByPhotoUrl!)
                          : null,
                      child: job.createdByPhotoUrl == null ||
                              job.createdByPhotoUrl!.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(context),
                    const SizedBox(height: 32),
                    const Text(
                      'Job Summary:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryGrid(context),
                    const SizedBox(height: 32),
                    const Text(
                      'Requirements',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.requirements.trim().isNotEmpty
                          ? job.requirements.trim()
                          : '-',
                      style: const TextStyle(height: 1.6, fontSize: 15),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Responsibilities:',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoints(job.responsibilities),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: job.createdBy == currentUser?.id
                          ? const Text(
                              "You can't apply to your own job.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryNavyBlue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => context.push('/apply-job'),
                              child: const Text(
                                'Apply',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9D6F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _handleProfileTap(context),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: job.createdByPhotoUrl != null &&
                          job.createdByPhotoUrl!.isNotEmpty
                      ? NetworkImage(job.createdByPhotoUrl!)
                      : null,
                  child: job.createdByPhotoUrl == null ||
                          job.createdByPhotoUrl!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.role,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A1258)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${job.company}, ${job.location}',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
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
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _tagChip(
                  job.category,
                  const Color(0xFFF3F0FF),
                  const Color(0xFF5B2E91),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildWorkModeTag(job.workMode),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: textColor,
          fontWeight: FontWeight.w500,
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

    return _tagChip(label, bgColor, textColor);
  }

  Widget _buildSummaryGrid(BuildContext context) {
    final items = [
      MapEntry('Working days', job.workingDays),
      MapEntry('Education', job.education),
      MapEntry('Category', job.category),
      MapEntry('Location', job.location),
      MapEntry('Salary', job.salary),
      MapEntry('Working hours', job.workingHours),
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 24,
      children: items.map((entry) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 3 - 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                entry.key,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                entry.value.trim().isNotEmpty ? entry.value : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBulletPoints(String text) {
    final lines = text
        .split(RegExp(r'[•\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (lines.isEmpty) return const Text('-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  line,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
