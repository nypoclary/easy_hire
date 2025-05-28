import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/job_filter_options.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selected = 'Yangon';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title: 'Welcome to EasyHire'),
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
                    tags: ['Flutter', 'Full time'],
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
