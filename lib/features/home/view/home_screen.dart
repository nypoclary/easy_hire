import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/job_filter_options.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/core/provider/location_provider.dart';
import 'package:easy_hire/core/provider/search_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(locationFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    // Define job data
    final jobData = [
      {
        'role': 'Product Designer',
        'company': 'Google inc California',
        'salary': '\$15K',
        'location': 'Yangon',
        'tags': ['Home Service', 'Remote'],
        'imageAsset': 'assets/images/profile_pic.jpg',
      },
      {
        'role': 'Mobile Dev',
        'company': 'Google inc California, USA',
        'salary': '\$14K',
        'location': 'Mandalay',
        'tags': ['Flutter', 'Full time'],
        'imageAsset': 'assets/images/profile_pic.jpg',
      },
    ];

    // Filter jobs based on location and through search bar
    final filteredJobs = jobData.where((job) {
      final role = (job['role'] as String).toLowerCase();
      final company = (job['company'] as String).toLowerCase();
      final tags = (job['tags'] as List).cast<String>();
      final location = (job['location'] as String).toLowerCase();

      final matchesLocation = selectedLocation == 'All'
          ? true
          : location == selectedLocation.toLowerCase();

      final matchesSearch = role.contains(searchQuery) ||
          company.contains(searchQuery) ||
          tags.any((tag) => tag.toLowerCase().contains(searchQuery));

      return matchesLocation && matchesSearch;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              title: 'Welcome to EasyHire',
              hasAddButton: true,
              hasBackButton: false,
            ),
            SizedBox(height: 24),
            JobSearchBar(
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
              },
            ),
            SizedBox(height: 20),
            LocationFilterChip(
              locationOptions: ['All', 'Yangon', 'Mandalay', 'Naypyitaw'],
            ),
            SizedBox(height: 20),
            JobFilterOptions(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Recent Jobs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: filteredJobs.isEmpty
                  ? Center(child: Text('No jobs found in $selectedLocation'))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = filteredJobs[index];
                        return JobCardWidget(
                          role: job['role'] as String,
                          company: job['company'] as String,
                          salary: job['salary'] as String,
                          tags: (job['tags'] as List).cast<String>(),
                          location: job['location'] as String,
                          imageAsset: job['imageAsset'] as String,
                          onTap: () {
                            debugPrint('🟣 Card tapped!');
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
