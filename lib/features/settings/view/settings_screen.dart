import 'package:easy_hire/core/models/google_user_data_model.dart';
import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:easy_hire/features/profile/view/profile_screen.dart';
import 'package:easy_hire/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const Color strokeWhite = Colors.white;
  static const Color darkIconPurple = Color(0xFF6B42C1);
  static const Color profileCardBackground = Color(0xFFF9F7FF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            _buildProfileCard(context, ref, cardShape),
            const SizedBox(height: 32),
            _buildSectionTitle("Account"),
            _buildSettingsCard(cardShape, [
              _buildSettingsTile(Icons.lightbulb_outline, "FAQ", () {}),
              _buildSettingsTile(
                  Icons.info_outline, "Terms and Policies", () {}),
              _buildSettingsTile(Icons.star_border, "Rate my app", () {}),
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle("Actions"),
            _buildSettingsCard(cardShape, [
              _buildSettingsTile(Icons.logout, "Log out", () {
                ref.read(googleAuthProvider.notifier).signOut();
              }),
              _buildSettingsTile(
                  Icons.cancel_outlined, "Delete Account", () {}),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, WidgetRef ref, ShapeBorder shape) {
    final user = ref.watch(googleAuthProvider).value;

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
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

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _aboutMeController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(googleAuthProvider).value;
    _usernameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _aboutMeController = TextEditingController(text: user?.aboutMe ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(googleAuthProvider).value;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user signed in')),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving changes...')),
      );

      final updatedName = _usernameController.text.trim();
      final updatedEmail = _emailController.text.trim();
      final updatedBio = _aboutMeController.text.trim();
      final updatedPhoto = user.photoUrl ?? '';

      final dioClient = DioClient();
      await dioClient.initialize();

      await dioClient.updateUserProfile(
        userId: user.id,
        name: updatedName,
        email: updatedEmail,
        photoUrl: updatedPhoto,
        aboutMe: updatedBio,
      );

      ref.read(googleAuthProvider.notifier).state = AsyncValue.data(
        GoogleUserData(
          id: user.id,
          email: updatedEmail,
          displayName: updatedName,
          photoUrl: updatedPhoto,
          aboutMe: updatedBio,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      //Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage:
                    ref.watch(googleAuthProvider).value?.photoUrl != null
                        ? NetworkImage(
                            ref.watch(googleAuthProvider).value!.photoUrl!)
                        : const AssetImage('assets/images/profile_pic.jpg')
                            as ImageProvider,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _usernameController,
                decoration: _inputDecoration('Username'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email'),
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter valid email'
                    : null,
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _aboutMeController,
                maxLines: 4,
                decoration: _inputDecoration('About Me'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter something about yourself'
                    : null,
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000F50),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
