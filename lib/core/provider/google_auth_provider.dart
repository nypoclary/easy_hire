import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_hire/core/models/google_user_data_model.dart';
import 'package:easy_hire/services/dio_client.dart';

class GoogleAuthNotifier extends StateNotifier<AsyncValue<GoogleUserData?>> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleAuthNotifier() : super(const AsyncValue.loading()) {
    _initializeAuth();
  }

  GoogleUserData? get currentUser => state.value;
  bool get isAuthenticated => state.value != null;

  /// 🔄 Try auto sign-in on startup
  Future<void> _initializeAuth() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        final user = await _fetchOrCreateUser(account);
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 🔑 Google sign-in
  Future<void> signIn() async {
    state = const AsyncValue.loading();
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        state = const AsyncValue.data(null); // User cancelled
        return;
      }

      final user = await _fetchOrCreateUser(account);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 🚪 Google sign-out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _googleSignIn.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 📡 Fetch user from backend, or create if not found
  Future<GoogleUserData> _fetchOrCreateUser(GoogleSignInAccount account) async {
    final dioClient = DioClient();
    await dioClient.initialize();

    final newUser = GoogleUserData(
      id: account.id,
      email: account.email,
      displayName: account.displayName,
      photoUrl: account.photoUrl,
      aboutMe: '',
    );

    try {
      final response = await dioClient.dio.get('/users/${account.id}');
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid user data format from backend');
      }

      return GoogleUserData(
        id: account.id,
        email: account.email,
        displayName: data['name'] ?? account.displayName,
        photoUrl: data['photoUrl'] ?? account.photoUrl,
        aboutMe: data['aboutMe'] ?? '',
      );
    } catch (_) {
      // User doesn't exist — create
      await dioClient.dio.post('/users', data: newUser.toJson());
      return newUser;
    }
  }
}

final googleAuthProvider = StateNotifierProvider<GoogleAuthNotifier, AsyncValue<GoogleUserData?>>(
  (ref) => GoogleAuthNotifier(),
);
