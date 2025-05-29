import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:easy_hire/core/widgets/job_card.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/features/job_search/provider/search_provider.dart';
import 'package:easy_hire/core/provider/location_provider.dart';
import 'package:easy_hire/features/job_detail/view/job_detail_screen.dart';

// Helper to extract category from tags
String extractJobCategory(List<String>? tags) {
  if (tags == null || tags.isEmpty) return 'Unknown';
  if (tags.any((tag) => tag.toLowerCase().contains('remote'))) return 'Remote';
  if (tags.any((tag) => tag.toLowerCase().contains('full'))) return 'Full-time';
  if (tags.any((tag) => tag.toLowerCase().contains('part'))) return 'Part-time';
  return 'Freelance';
}

// Helper to convert 15K → 150000Ks
String convertToKs(String salary) {
  final match = RegExp(r'\$(\d+)K').firstMatch(salary);
  if (match != null) {
    final value = int.parse(match.group(1)!);
    return '${value * 1000}Ks';
  }
  return salary;
}

class JobSearchScreen extends ConsumerStatefulWidget {
  final String? category;

  const JobSearchScreen({super.key, required this.category});

  @override
  ConsumerState<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends ConsumerState<JobSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final jobData = [
      {
        'role': 'Product Designer',
        'company': 'Google inc California',
        'salary': '\$15K',
        'location': 'Yangon',
        'tags': ['Home Service', 'Remote'],
        'workingDays': 'Mon–Sat',
        'education': 'Grade 10th',
        'workingHours': '4–10pm',
        'requirements': 'Strong UX skills and design system experience...',
        'responsibilities':
            '• Conduct user research...\n• Create flows...\n• Collaborate with product team...',
      },
      {
        'role': 'Mobile Dev',
        'company': 'Google inc California',
        'salary': '\$14K',
        'location': 'Mandalay',
        'tags': ['Flutter', 'Full time'],
        'workingDays': 'Mon–Fri',
        'education': 'Bachelor’s Degree',
        'workingHours': '9am–5pm',
        'requirements': 'Flutter knowledge and clean architecture.',
        'responsibilities': '• Build apps\n• Fix bugs\n• Work with backend...',
      },
      {
        'role': 'Sales and business',
        'company': 'Google inc California',
        'salary': '\$14K',
        'location': 'Naypyitaw',
        'tags': ['Real Estate', 'Part time'],
        'workingDays': 'Tue–Sun',
        'education': 'Any Degree',
        'workingHours': '10am–4pm',
        'requirements': 'Good communication skills.',
        'responsibilities':
            '• Meet clients\n• Close deals\n• Maintain records...',
      },
    ];

    final selectedLocation = ref.watch(locationFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    final filteredJobs = jobData.where((job) {
      final role = (job['role'] as String).toLowerCase();
      final company = (job['company'] as String).toLowerCase();
      final tags = (job['tags'] as List).cast<String>();

      final matchesCategory =
          widget.category != null && widget.category != 'all'
              ? tags.any((tag) =>
                  tag.toLowerCase().contains(widget.category!.toLowerCase()))
              : true;

      final matchesSearch = role.contains(searchQuery) ||
          company.contains(searchQuery) ||
          tags.any((tag) => tag.toLowerCase().contains(searchQuery));

      final matchesLocation = selectedLocation == 'All'
          ? true
          : (job['location'] as String)
              .toLowerCase()
              .trim()
              .contains(selectedLocation.toLowerCase());

      return matchesCategory && matchesSearch && matchesLocation;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.category != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/'),
                ),
              ),
            Header(
              title: widget.category != null
                  ? '${widget.category} Jobs'
                  : 'All Jobs',
            ),
            const SizedBox(height: 24),
            JobSearchBar(
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
              },
            ),
            const SizedBox(height: 20),
            LocationFilterChip(
              locationOptions: ['All', 'Yangon', 'Mandalay', 'Naypyitaw'],
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'All Jobs Available',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index];
                  final tags = (job['tags'] as List).cast<String>();
                  return JobCardWidget(
                    role: job['role'] as String,
                    company: job['company'] as String,
                    salary: job['salary'] as String,
                    location: job['location'] as String,
                    tags: tags,
                    imageAsset: 'assets/images/profile_pic.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailScreen(
                            role: job['role'] as String,
                            company: job['company'] as String,
                            salary: job['salary'] as String,
                            tags: tags,
                            requirements: job['requirements'] as String,
                            responsibilities: job['responsibilities'] as String,
                            jobSummary: {
                              'Working days': job['workingDays'] as String,
                              'Education': job['education'] as String,
                              'Category': extractJobCategory(tags),
                              'Location': job['location'] as String,
                              'Salary': convertToKs(job['salary'] as String),
                              'Working hours': job['workingHours'] as String,
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
