import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_hire/core/app_theme.dart';

class JobApplyScreen extends StatefulWidget {
  const JobApplyScreen({super.key});

  @override
  State<JobApplyScreen> createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends State<JobApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _educationController = TextEditingController();
  final _otherRequestController = TextEditingController();

  final Color lightPurple = const Color(0xFFD1C4E9);

  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color(0xFFD1C4E9)),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _educationController.dispose();
    _otherRequestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: const Text(
          'Apply Job',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader('Basic Info'),
                _inputField('Name', controller: _nameController),
                _inputField('Email', controller: _emailController),
                _inputField('Education / Certifications',
                    controller: _educationController, maxLines: 4),
                _sectionHeader('Other Requests (Optional)'),
                _inputField('',
                    controller: _otherRequestController, maxLines: 4),
                const SizedBox(height: 24),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
        ),
      );

  Widget _inputField(String label,
      {required TextEditingController controller, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87),
              ),
            ),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: _border,
              enabledBorder: _border,
              focusedBorder: _border.copyWith(
                borderSide: BorderSide(color: lightPurple, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // TODO: Submit or go to next screen
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryNavyBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
