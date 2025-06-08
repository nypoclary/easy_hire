import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/delete_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/core/provider/application_provider.dart';
import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:easy_hire/core/models/job_application_model.dart';

class JobStatusScreen extends ConsumerStatefulWidget {
  const JobStatusScreen({super.key});

  @override
  ConsumerState<JobStatusScreen> createState() => _JobStatusScreenState();
}

class _JobStatusScreenState extends ConsumerState<JobStatusScreen> {
  String searchQuery = '';

  // Helper methods to handle status
  Color getBorderColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.pending:
        return Colors.amber;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }

  Color getStatusBgColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.accepted:
        return Colors.green.shade100;
      case ApplicationStatus.pending:
        return Colors.amber.shade100;
      case ApplicationStatus.rejected:
        return Colors.red.shade100;
    }
  }

  Color getStatusTextColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.accepted:
        return Colors.green.shade800;
      case ApplicationStatus.pending:
        return Colors.orange.shade800;
      case ApplicationStatus.rejected:
        return Colors.red.shade800;
    }
  }

  String getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.accepted:
        return 'accepted';
      case ApplicationStatus.pending:
        return 'pending';
      case ApplicationStatus.rejected:
        return 'rejected';
    }
  }

  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  Widget buildJobCard(JobApplicationModel application) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: getBorderColor(application.status), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8FF),
                  shape: BoxShape.circle,
                ),
                child: application.companyPhotoUrl != null &&
                        application.companyPhotoUrl!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          application.companyPhotoUrl!,
                          fit: BoxFit.cover,
                          width: 44,
                          height: 44,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.business,
                            size: 24,
                            color: Color(0xFF6B46C1),
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.business,
                        size: 24,
                        color: Color(0xFF6B46C1),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.jobTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2A1258),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      application.companyName,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge positioned at top right
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getBorderColor(application.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getStatusText(application.status),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: getStatusTextColor(application.status),
                      ),
                    ),
                    if (application.status == ApplicationStatus.rejected) ...[
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => DeleteConfirmationDialog(
                              onConfirm: () async {
                                Navigator.pop(context);

                                try {
                                  await ref
                                      .read(
                                          applicationDeletionProvider.notifier)
                                      .deleteApplication(application.id);

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Application deleted successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (error) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to delete application: ${error.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              onCancel: () => Navigator.pop(context),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 16,
                          color: Color.fromARGB(255, 245, 7, 7),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: application.salary,
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
              if (application.tags.isNotEmpty) ...[
                Expanded(
                  child: _buildTag(
                    application.tags.first,
                    const Color(0xFFF3F0FF),
                    const Color(0xFF5B2E91),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (application.tags.length > 1)
                Expanded(
                  child: _buildWorkModeTag(application.tags[1]),
                ),
              if (application.tags.length == 1)
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(googleAuthProvider).value;

    if (user == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('Please sign in to view your applications'),
          ),
        ),
      );
    }

    final applicationsAsync = ref.watch(userApplicationsProvider(user.id));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with refresh button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Header(title: 'Applied Job Status'),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.invalidate(userApplicationsProvider(user.id));
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Color(0xFF6B46C1),
                      size: 24,
                    ),
                    tooltip: 'Refresh applications',
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFE8E2FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: applicationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading applications: ${error.toString()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            ref.invalidate(userApplicationsProvider(user.id)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (applications) {
                  final filteredApplications = applications.where((app) {
                    if (searchQuery.isEmpty) return true;
                    return app.jobTitle
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()) ||
                        app.companyName
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filteredApplications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.work_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            applications.isEmpty
                                ? 'No applications yet'
                                : 'No applications match your search',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            applications.isEmpty
                                ? 'Start applying for jobs to see them here'
                                : 'Try a different search term',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 24),
                      JobSearchBar(
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      ...filteredApplications.map((app) => buildJobCard(app)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
