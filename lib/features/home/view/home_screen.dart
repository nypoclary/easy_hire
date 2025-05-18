import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/header.dart';

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
            SizedBox(height: 8),
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
            Expanded(
              child: Center(
                child: Text(
                  'This is home screen',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
