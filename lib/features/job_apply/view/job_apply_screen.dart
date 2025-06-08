import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_hire/core/app_theme.dart';
import 'package:easy_hire/core/models/job_model.dart';
import 'package:easy_hire/core/provider/application_provider.dart';
import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobApplyScreen extends ConsumerStatefulWidget {
  final JobModel job;

  const JobApplyScreen({super.key, required this.job});

  @override
  ConsumerState<JobApplyScreen> createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends ConsumerState<JobApplyScreen> {
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
            validator: (value) {
              if (label == 'Name' && (value == null || value.trim().isEmpty)) {
                return 'Name is required';
              }
              if (label == 'Email') {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value.trim())) {
                  return 'Please enter a valid email';
                }
              }
              if (label == 'Education / Certifications' &&
                  (value == null || value.trim().isEmpty)) {
                return 'Education/Certifications is required';
              }
              return null;
            },
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
    final applicationState = ref.watch(applicationSubmissionProvider);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: applicationState.isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryNavyBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: applicationState.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Submit',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white),
              ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(googleAuthProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to apply for jobs')),
      );
      return;
    }

    // Prepare application data
    final applicationData = {
      'jobId': widget.job.id,
      'applicantId': user.id,
      'applicantName': _nameController.text.trim(),
      'applicantEmail': _emailController.text.trim(),
      'education': _educationController.text.trim(),
      'otherRequests': _otherRequestController.text.trim().isEmpty
          ? null
          : _otherRequestController.text.trim(),
      // Job details for display in applications list
      'jobTitle': widget.job.role,
      'companyName': widget.job.company,
      'salary': widget.job.salary,
      'companyPhotoUrl': widget.job.createdByPhotoUrl,
      'tags': [widget.job.category, widget.job.workMode]
          .where((tag) => tag.isNotEmpty)
          .toList(),
    };

    try {
      await ref
          .read(applicationSubmissionProvider.notifier)
          .submitApplication(applicationData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // Go back to previous screen
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit application: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
