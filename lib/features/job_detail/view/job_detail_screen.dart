import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/job_card.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:go_router/go_router.dart';

class JobDetailScreen extends StatelessWidget {
  final String role;
  final String company;
  final String salary;
  final List<String> tags;
  final String requirements;
  final String responsibilities;
  final Map<String, String> jobSummary;

  const JobDetailScreen({
    super.key,
    required this.role,
    required this.company,
    required this.salary,
    required this.tags,
    required this.requirements,
    required this.responsibilities,
    required this.jobSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FF),
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: 'Job Details',
              hasBackButton: true,
              hasAddButton: false,
              onBackPressed: () => context.pop(), // or context.go('/') if needed
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    JobCardWidget(
                      role: role,
                      company: company,
                      salary: salary,
                      tags: tags,
                      location: 'Yangon',
                      imageAsset: 'assets/images/profile_pic.jpg',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Job Summary:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 30,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: jobSummary.entries.map((entry) {
                        return _summaryBlock(entry.key, entry.value);
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Requirements',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        requirements,
                        style: TextStyle(
                            height: 1.4), // optional: improves line spacing
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Responsibilities:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        responsibilities,
                        style: TextStyle(
                            height: 1.4), // optional: improves line spacing
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 900,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF000959),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Apply',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _summaryBlock(String label, String value) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
