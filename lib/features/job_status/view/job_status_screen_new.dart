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
        return Colors.green.shade600;
      case ApplicationStatus.pending:
        return Colors.orange.shade600;
      case ApplicationStatus.rejected:
        return Colors.red.shade600;
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

  Widget buildJobCard(JobApplicationModel application) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: getBorderColor(application.status), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: application.companyPhotoUrl != null &&
                        application.companyPhotoUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          application.companyPhotoUrl!,
                          fit: BoxFit.cover,
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            application.jobTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A1258),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: getBorderColor(application.status)
                                .withOpacity(0.1),
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
                              if (application.status ==
                                  ApplicationStatus.rejected) ...[
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => DeleteConfirmationDialog(
                                        onConfirm: () {
                                          // TODO: Implement delete functionality
                                          Navigator.pop(context);
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            application.companyName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
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
            children: application.tags.map((tag) {
              final isRemote = tag.toLowerCase().contains('remote');
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isRemote
                      ? const Color(0xFFFFE4D6)
                      : const Color(0xFFE8E2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isRemote ? const Color(0xFFDE6E35) : Colors.black,
                  ),
                ),
              );
            }).toList(),
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
            const Header(title: 'Applied Job Status'),
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
                            ref.refresh(userApplicationsProvider(user.id)),
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
