import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:easy_hire/core/widgets/job_card.dart';
import 'package:go_router/go_router.dart';

class JobSearchScreen extends StatefulWidget {
  final String? category;

  const JobSearchScreen({super.key, required this.category});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  String selected = 'Yangon';

  @override
  Widget build(BuildContext context) {
    final jobData = [
      {
        'role': 'Product Designer',
        'company': 'Google inc California, USA',
        'salary': '\$15K',
        'tags': ['Home Service', 'Remote'],
      },
      {
        'role': 'Mobile Dev',
        'company': 'Google inc California, USA',
        'salary': '\$14K',
        'tags': ['Flutter', 'Full time'],
      },
      {
        'role': 'Sales and business',
        'company': 'Google inc California, USA',
        'salary': '\$14K',
        'tags': ['Real Estate', 'Part time'],
      },
    ];


    final filteredJobs = widget.category != null && widget.category != 'all'
        ? jobData.where((job) {
      final tags = (job['tags'] as List).cast<String>();
      return tags.any((tag) =>
          tag.toLowerCase().contains(widget.category!.toLowerCase()));
    }).toList()
        : jobData;

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
                print("Search input: $query");
              },
            ),
            SizedBox(height: 20),
            LocationFilterChip(
              selectedLocation: selected,
              locationOptions: ['All', 'Yangon', 'Mandalay', 'Naypyitaw'],
              onChanged: (value) {
                setState(() {
                  selected = value!;
                  // Then filter your cards here
                });
              },
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
            // Expanded(
            //   child: ListView(
            //     padding: EdgeInsets.symmetric(horizontal: 16),
            //     children: [
            //       JobCardWidget(
            //         role: 'Product Designer',
            //         company: 'Google inc  California, USA',
            //         salary: '\$15K',
            //         tags: ['Home Service', 'Remote'],
            //         imageAsset: 'assets/images/profile_pic.jpg',
            //         onTap: () {
            //           debugPrint('🟣 Card tapped!');
            //         },
            //       ),
            //       JobCardWidget(
            //         role: 'Mobile Dev',
            //         company: 'Google inc  California, USA',
            //         salary: '\$14K',
            //         tags: ['Flutter', 'Full time'],
            //         imageAsset: 'assets/images/profile_pic.jpg',
            //         onTap: () {
            //           debugPrint('🟣 Card tapped!');
            //         },
            //       ),
            //       JobCardWidget(
            //         role: 'Product Designer',
            //         company: 'Google inc  California, USA',
            //         salary: '\$15K',
            //         tags: ['Home Service', 'Remote'],
            //         imageAsset: 'assets/images/profile_pic.jpg',
            //         onTap: () {
            //           debugPrint('🟣 Card tapped!');
            //         },
            //       ),
            //       JobCardWidget(
            //         role: 'Sales and business',
            //         company: 'Google inc  California, USA',
            //         salary: '\$14K',
            //         tags: ['Real Estate', 'Part time'],
            //         imageAsset: 'assets/images/profile_pic.jpg',
            //         onTap: () {
            //           debugPrint('🟣 Card tapped!');
            //         },
            //       ),
            //       JobCardWidget(
            //         role: 'Sales and business',
            //         company: 'Google inc  California, USA',
            //         salary: '\$14K',
            //         tags: ['Real Estate', 'Part time'],
            //         imageAsset: 'assets/images/profile_pic.jpg',
            //         onTap: () {
            //           debugPrint('🟣 Card tapped!');
            //         },
            //       ),
            //     ],
            //   ),
            // ),
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
