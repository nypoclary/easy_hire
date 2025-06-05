import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:easy_hire/services/dio_client.dart';
import 'package:easy_hire/core/models/google_user_data_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  static const Color headerBackground = Color(0xFF1C2E74);
  static const Color cardBackground = Colors.white;
  static const Color textColor = Colors.black87;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _aboutMeController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _aboutMeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(googleAuthProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ProfileScreen.headerBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not signed in.'));
          }

          // Set default aboutMe text if empty
          if (_aboutMeController.text.isEmpty) {
            _aboutMeController.text =
                user.aboutMe?.trim().isNotEmpty == true ? user.aboutMe! : 'A short bio about yourself goes here...';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                _buildHeader(user),
                const SizedBox(height: 90),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _infoTile('Username', user.displayName ?? 'N/A'),
                      const SizedBox(height: 24),
                      _infoTile('Email', user.email ?? 'N/A'),
                      const SizedBox(height: 24),
                      _aboutMeField(),
                      const SizedBox(height: 24),
                      _buildSaveButton(user),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(GoogleUserData user) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            color: ProfileScreen.headerBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        Positioned(
          bottom: -70,
          left: 0,
          right: 0,
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : const AssetImage('assets/images/profile_pic.jpg') as ImageProvider,
              ),
              const SizedBox(height: 14),
              Text(
                user.displayName ?? 'No Name',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTile(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProfileScreen.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: ProfileScreen.textColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutMeField() {
    return TextField(
      controller: _aboutMeController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'About Me',
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSaveButton(GoogleUserData user) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSaving ? null : () => _saveProfile(user),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C2E74),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSaving
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Save', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<void> _saveProfile(GoogleUserData user) async {
    setState(() => _isSaving = true);
    try {
      final updatedBio = _aboutMeController.text.trim();

      await DioClient().updateUserProfile(
        userId: user.id, // ✅ fix: use user.id not uid
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoUrl ?? '',
        aboutMe: updatedBio,
      );

      // ✅ Update local state
      ref.read(googleAuthProvider.notifier).state = AsyncValue.data(
        GoogleUserData(
          id: user.id,
          email: user.email,
          displayName: user.displayName,
          photoUrl: user.photoUrl,
          aboutMe: updatedBio,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
