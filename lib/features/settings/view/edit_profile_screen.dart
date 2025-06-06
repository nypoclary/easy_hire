import 'package:easy_hire/core/models/google_user_data_model.dart';
import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:easy_hire/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        const SnackBar(content: Text('Saving changes')),
      );

      final updatedUser = GoogleUserData(
        id: user.id,
        email: _emailController.text.trim(),
        displayName: _usernameController.text.trim(),
        photoUrl: user.photoUrl,
        aboutMe: _aboutMeController.text.trim(),
      );

      final dioClient = DioClient();
      await dioClient.initialize();
      await dioClient.updateUserProfile(
        userId: updatedUser.id,
        name: updatedUser.displayName ?? '',
        email: updatedUser.email,
        photoUrl: updatedUser.photoUrl ?? '',
        aboutMe: updatedUser.aboutMe ?? '',
      );

      ref.read(googleAuthProvider.notifier).state =
          AsyncValue.data(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );

      Navigator.pop(context);
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
    final user = ref.watch(googleAuthProvider).value;

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
                backgroundImage: user?.photoUrl != null
                    ? NetworkImage(user!.photoUrl!)
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
                    style: TextStyle(fontSize: 14, color: Colors.white),
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
