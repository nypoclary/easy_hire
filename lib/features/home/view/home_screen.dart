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
            // header section with solid background
            Container(
              color: Colors.white,
              child: Header(
                title: 'Welcome to EasyHire',
                hasAddButton: true,
                hasBackButton: false,
              ),
            ),

            // Search bar and location filter with elevation
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
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
                ],
              ),
            ),
            Container(
              height: 4,
              color: Colors.white,
            ),

            // Scrollable content
            Expanded(
              child: ClipRRect( // Clip the scrollable content
                child: filteredJobs.isEmpty
                    ? Center(child: Text('No jobs found in $selectedLocation'))
                    : ListView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16),
                  children: [
                    JobFilterOptions(),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 20.0, right: 20.0),
                      child: Text(
                        'All Jobs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    ...filteredJobs.map((job) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: JobCardWidget(
                        role: job['role'] as String,
                        company: job['company'] as String,
                        salary: job['salary'] as String,
                        tags: (job['tags'] as List).cast<String>(),
                        location: job['location'] as String,
                        imageAsset: job['imageAsset'] as String,
                        onTap: () {
                          debugPrint('🟣 Card tapped!');
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
