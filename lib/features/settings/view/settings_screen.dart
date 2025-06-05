import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:easy_hire/features/profile/view/profile_screen.dart';
import 'package:easy_hire/features/settings/view/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const Color strokeWhite = Colors.white;
  static const Color darkIconPurple = Color(0xFF6B42C1);
  static const Color profileCardBackground = Color(0xFFF9F7FF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(googleAuthProvider).value;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: strokeWhite),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context, user, cardShape),
            const SizedBox(height: 32),
            _buildSectionTitle("Account"),
            _buildSettingsCard(cardShape, [
              _buildSettingsTile(Icons.lightbulb_outline, "FAQ", () {}),
              _buildSettingsTile(Icons.info_outline, "Terms and Policies", () {}),
              _buildSettingsTile(Icons.info_outline, "About us", () {}),
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle("Actions"),
            _buildSettingsCard(cardShape, [
              _buildSettingsTile(Icons.logout, "Log out", () {
                ref.read(googleAuthProvider.notifier).signOut();
              }),
              _buildSettingsTile(Icons.cancel_outlined, "Delete Account", () {}),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, dynamic user, ShapeBorder shape) {
    return Card(
      elevation: 4,
      shape: shape,
      color: profileCardBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not signed in')),
                  );
                }
              },
              child: CircleAvatar(
                radius: 42,
                backgroundImage: user?.photoUrl != null
                    ? NetworkImage(user!.photoUrl!)
                    : const AssetImage('assets/images/profile_pic.jpg')
                        as ImageProvider,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? 'Guest User',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(user?.email ?? '',
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: darkIconPurple),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildSettingsCard(ShapeBorder shape, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: shape,
      color: Colors.white,
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(IconData icon, String label, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: darkIconPurple),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}
