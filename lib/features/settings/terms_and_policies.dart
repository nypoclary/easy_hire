import 'package:flutter/material.dart';

class TermsAndPoliciesScreen extends StatelessWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 195, 171, 246), // Use your AppTheme.primaryNavyBlue
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
            constraints: const BoxConstraints(maxWidth: 600),
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
                    // Only center this title
                    child: Text(
                      'Terms and Conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Purpose',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'EasyHire is designed to connect job seekers with potential employers in a streamlined, professional, and efficient manner. It serves as a digital hiring hub, allowing users to search, post, and apply for jobs with ease.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Account Responsibility',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Users are responsible for maintaining the confidentiality of their login credentials and all activities that occur under their account. Please ensure your password is secure and updated regularly.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Content Use',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'All content shared on EasyHire must be accurate, lawful, and respectful. Users are prohibited from uploading misleading, defamatory, or copyrighted material without permission.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Professional Conduct',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Users are expected to behave professionally and respectfully when interacting with others on the platform. Discrimination, harassment, or any form of abuse will result in account suspension.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No Guarantee',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'EasyHire provides tools for hiring and job searching, but does not guarantee employment or the quality of candidates. Users must evaluate and verify opportunities independently.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Updates',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'We may update these terms periodically. Your continued use of the app after changes are made indicates your acceptance of the revised terms and conditions.',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please review our Privacy Policy for details on how your data is used.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Thank you for being part of EasyHire.',
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
