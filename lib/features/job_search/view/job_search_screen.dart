import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:easy_hire/core/widgets/job_card.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/features/job_search/provider/search_provider.dart';
import 'package:easy_hire/core/provider/location_provider.dart';

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
      },
      {
        'role': 'Mobile Dev',
        'company': 'Google inc California',
        'salary': '\$14K',
        'location': 'Mandalay',
        'tags': ['Flutter', 'Full time'],
      },
      {
        'role': 'Sales and business',
        'company': 'Google inc California',
        'salary': '\$14K',
        'location': 'Naypyitaw',
        'tags': ['Real Estate', 'Part time'],
      },
    ];
    final selectedLocation = ref.watch(locationFilterProvider);

//search bar function
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
              .toLowerCase().trim()
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
                    : 'All Jobs'),
            SizedBox(height: 24),
            JobSearchBar(
              onChanged: (query) {
                //  Add search/filter logic here
                ref.read(searchQueryProvider.notifier).state = query;
              },
            ),
            SizedBox(height: 20),
            LocationFilterChip(
              locationOptions: ['All', 'Yangon', 'Mandalay', 'Naypyitaw'],
            ),
            SizedBox(height: 8),
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
                  return JobCardWidget(
                    role: job['role'] as String,
                    company: job['company'] as String,
                    salary: job['salary'] as String,
                    location: job['location'] as String,
                    tags: (job['tags'] as List).cast<String>(),
                    imageAsset: 'assets/images/profile_pic.jpg',
                    onTap: () => debugPrint('🟣 Card tapped!'),
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
