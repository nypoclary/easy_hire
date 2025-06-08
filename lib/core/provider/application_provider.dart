import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/core/models/job_application_model.dart';
import 'package:easy_hire/core/provider/job_provider.dart';

// ✅ Provider to submit a job application
final submitApplicationProvider =
    FutureProvider.family<void, Map<String, dynamic>>(
  (ref, applicationData) async {
    final dioClient = ref.read(dioClientProvider);
    await dioClient.initialize();
    await dioClient.submitJobApplication(applicationData);
  },
);

// ✅ Provider to fetch user's applications
final userApplicationsProvider =
    FutureProvider.family<List<JobApplicationModel>, String>(
  (ref, userId) async {
    final dioClient = ref.read(dioClientProvider);
    await dioClient.initialize();

    final applications = await dioClient.getUserApplications(userId);
    final applicationList = applications
        .map((app) => JobApplicationModel.fromMap(app, app['id']))
        .toList();

    // Sort by appliedAt date (newest first)
    applicationList.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

    return applicationList;
  },
);

// ✅ Provider to fetch applications for a specific job (for employers)
final jobApplicationsProvider =
    FutureProvider.family<List<JobApplicationModel>, String>(
  (ref, jobId) async {
    final dioClient = ref.read(dioClientProvider);
    await dioClient.initialize();

    final applications = await dioClient.getJobApplications(jobId);
    return applications
        .map((app) => JobApplicationModel.fromMap(app, app['id']))
        .toList();
  },
);

// ✅ State notifier for managing application submission state
class ApplicationSubmissionNotifier extends StateNotifier<AsyncValue<void>> {
  ApplicationSubmissionNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> submitApplication(Map<String, dynamic> applicationData) async {
    state = const AsyncValue.loading();

    try {
      final dioClient = ref.read(dioClientProvider);
      await dioClient.initialize();
      await dioClient.submitJobApplication(applicationData);
      state = const AsyncValue.data(null);

      // Invalidate user applications to refresh the list
      ref.invalidate(userApplicationsProvider);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

final applicationSubmissionProvider =
    StateNotifierProvider<ApplicationSubmissionNotifier, AsyncValue<void>>(
  (ref) => ApplicationSubmissionNotifier(ref),
);
