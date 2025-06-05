import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 171, 246),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 195, 171, 246),
        title: const Text("About Us", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Frequently Asked Questions',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'How do I apply for a job?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Browse available job listings, select the one you are interested in, and tap "Apply" to follow the application steps.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Can I change my bio?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Yes. Go to your profile and tap the edit icon to update your bio, name, or other profile details.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Can I post a job from my own account?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Yes. As an employer or recruiter, you can use your EasyHire account to create and publish job listings.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Is my data secure?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Absolutely. We implement strict security standards to protect your personal and professional data.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Can I delete my account?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Yes. Go to Settings > Delete Account. Note that this action is permanent and cannot be undone.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'What should I do if I forgot my password?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Use the "Forgot Password" option on the login screen to reset it via email.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'How can I contact support?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'You can reach our support team through the Contact Us option in the app or by emailing support@easyhire.com.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Is it really trustful source to find job?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'EasyHire is built with user trust and data integrity at its core. We use secure authentication, encrypted storage, and follow best practices in privacy and safety to ensure your personal and professional information is protected. Thousands of users rely on EasyHire to connect with real job opportunities and hiring professionals every day.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
