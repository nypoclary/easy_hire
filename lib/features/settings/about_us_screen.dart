import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
                      'About Us',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'EasyHire is a modern job-matching platform designed to simplify the hiring process for both job seekers and employers. We aim to empower individuals by giving them direct access to verified opportunities and trustworthy employers across various industries.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Our mission is to make hiring and getting hired easier, faster, and more human. We believe that finding a job or the right candidate should be seamless, transparent, and empowering for everyone involved.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'With EasyHire, users can create detailed profiles, explore curated job listings, apply with one tap, and communicate directly within the platform — all in a secure and supportive environment.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'We are continuously improving and innovating based on feedback from our users. Whether you’re starting your career, changing paths, or hiring top talent, EasyHire is here to support your journey.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'In addition to core job features, EasyHire offers personalized job recommendations, interview tracking tools, and messaging to help streamline the entire job-seeking and hiring process. Our goal is to reduce friction and help you focus on making the right connections.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Behind EasyHire is a passionate team of engineers, recruiters, and designers who believe employment should be accessible, efficient, and fair for everyone — regardless of background or location.',
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Thank you for choosing EasyHire.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
