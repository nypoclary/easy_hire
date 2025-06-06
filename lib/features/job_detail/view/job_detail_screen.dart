import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_hire/core/models/job_model.dart';
import 'package:easy_hire/core/widgets/job_card.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/app_theme.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

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
              onBackPressed: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JobCardWidget(job: job, onTap: () {}),
                    const SizedBox(height: 24),
                    const Text(
                      'Job Summary:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAlignedSummary(job),
                    const SizedBox(height: 32),
                    const Text(
                      'Requirements',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.requirements.trim().isNotEmpty
                          ? job.requirements.trim()
                          : '-',
                      style: const TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Responsibilities:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoints(job.responsibilities),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryNavyBlue,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => context.push('/apply-job'),
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

  /// Builds 3 aligned columns from dynamic + static fields
  static Widget _buildAlignedSummary(JobModel job) {
    final summaryItems = <MapEntry<String, String>>[
      // ...job.jobSummary.entries,
      MapEntry('Location', job.location),
      MapEntry('Salary', job.salary),
      MapEntry('Category', job.type),
    ];

    final columns = <List<MapEntry<String, String>>>[[], [], []];
    for (int i = 0; i < summaryItems.length; i++) {
      columns[i % 3].add(summaryItems[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: columns.map((col) {
        return Column(
          children: col
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _alignedSummaryBlock(e.key, e.value),
                  ))
              .toList(),
        );
      }).toList(),
    );
  }

  static Widget _alignedSummaryBlock(String label, String value) {
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.5,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value.trim().isNotEmpty ? value.trim() : '-',
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

  static Widget _buildBulletPoints(String text) {
    final lines = text
        .split(RegExp(r'[•\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (lines.isEmpty) return const Text('-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  line,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
