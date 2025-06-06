import 'package:easy_hire/services/dio_client.dart';
import 'package:easy_hire/core/models/google_user_data_model.dart';

Future<GoogleUserData> fetchUserById(String userId) async {
  final dioClient = DioClient();
  await dioClient.initialize();

  try {
    final response = await dioClient.dio.get('/users/$userId');
    final data = response.data;

    print("📦 Response from /users/$userId: $data");

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid user data format');
    }

    return GoogleUserData(
      id: userId, // use the known ID
      email: data['email'] ?? '',
      displayName: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      aboutMe: data['aboutMe'] ?? '',
    );
  } catch (e) {
    print('❌ Error in fetchUserById: $e');
    rethrow;
  }
}
