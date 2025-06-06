import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/core/models/job_model.dart';
import 'package:easy_hire/services/dio_client.dart';

// ✅ Provider for DioClient instance
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// ✅ Fetch all job posts
final jobListProvider = FutureProvider<List<JobModel>>((ref) async {
  final dio = ref.read(dioClientProvider).dio;
  final response = await dio.get('/jobs');

  final data = response.data as List;
  return data.map((json) {
    final id = json['id'] ?? ''; // Ensure ID is extracted
    return JobModel.fromMap(json, id);
  }).toList();
});

// ✅ Fetch a single job by ID
final singleJobProvider =
    FutureProvider.family<JobModel, String>((ref, jobId) async {
  final dio = ref.read(dioClientProvider).dio;
  final response = await dio.get('/jobs/$jobId');

  final data = response.data;
  return JobModel.fromMap(data, data['id']);
});
