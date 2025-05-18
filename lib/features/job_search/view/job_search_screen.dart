import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:easy_hire/core/widgets/job_card.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  String selected = 'Yangon';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title: 'All Jobs'),
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  JobCardWidget(
                    role: 'Product Designer',
                    company: 'Google inc  California, USA',
                    salary: '\$15K',
                    tags: ['Home Service', 'Remote'],
                    imageAsset: 'assets/images/profile_pic.jpg',
                    onTap: () {
                      debugPrint('🟣 Card tapped!');
                    },
                  ),
                  JobCardWidget(
                    role: 'Mobile Dev',
                    company: 'Google inc  California, USA',
                    salary: '\$14K',
                    tags: ['Flutter', 'Remote'],
                    imageAsset: 'assets/images/profile_pic.jpg',
                    onTap: () {
                      debugPrint('🟣 Card tapped!');
                    },
                  ),
                  JobCardWidget(
                    role: 'Product Designer',
                    company: 'Google inc  California, USA',
                    salary: '\$15K',
                    tags: ['Home Service', 'Remote'],
                    imageAsset: 'assets/images/profile_pic.jpg',
                    onTap: () {
                      debugPrint('🟣 Card tapped!');
                    },
                  ),
                  JobCardWidget(
                    role: 'Mobile Dev',
                    company: 'Google inc  California, USA',
                    salary: '\$14K',
                    tags: ['Flutter', 'Remote'],
                    imageAsset: 'assets/images/profile_pic.jpg',
                    onTap: () {
                      debugPrint('🟣 Card tapped!');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
