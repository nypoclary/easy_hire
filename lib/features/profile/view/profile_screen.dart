import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:easy_hire/core/models/google_user_data_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const Color headerBackground = Color(0xFF1C2E74);
  static const Color cardBackground = Colors.white;
  static const Color textColor = Colors.black87;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(googleAuthProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: headerBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                      _infoTile(
                        'About Me',
                        user.aboutMe?.trim().isNotEmpty == true
                            ? user.aboutMe!
                            : 'A short bio about yourself goes here...',
                      ),
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
            color: headerBackground,
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
                    : const AssetImage('assets/images/profile_pic.jpg')
                        as ImageProvider,
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
        color: cardBackground,
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
              color: textColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
