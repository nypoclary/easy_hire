import 'package:easy_hire/core/widgets/job_card.dart';
import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/job_filter_options.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/provider/job_provider.dart';
import 'package:easy_hire/core/models/job_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/core/provider/location_provider.dart';
import 'package:easy_hire/core/provider/search_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(locationFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    // Define job data
    final jobListAsync = ref.watch(jobListProvider);

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
              child: Consumer(
                builder: (context, ref, _) {
                  final jobListAsync = ref.watch(jobListProvider);
                  final selectedLocation = ref.watch(locationFilterProvider);
                  final searchQuery =
                      ref.watch(searchQueryProvider).toLowerCase();

                  return jobListAsync.when(
                    data: (jobs) {
                      final filtered = jobs
                          .where((job) {
                            final matchesLocation = selectedLocation == 'All' ||
                                job.location
                                    .toLowerCase()
                                    .contains(selectedLocation.toLowerCase());

                            final matchesSearch = searchQuery.isEmpty ||
                                job.role.toLowerCase().contains(searchQuery) ||
                                job.company
                                    .toLowerCase()
                                    .contains(searchQuery) ||
                                job.tag.toLowerCase().contains(searchQuery) ||
                                job.type.toLowerCase().contains(searchQuery);

                            return matchesLocation && matchesSearch;
                          })
                          .take(5)
                          .toList();

                      return filtered.isEmpty
                          ? Center(
                              child: Text('No jobs found in $selectedLocation'))
                          : ListView(
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.only(top: 16),
                              children: [
                                const JobFilterOptions(),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 12.0, left: 20.0, right: 20.0),
                                  child: Text(
                                    'All Jobs',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...filtered.map((job) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: JobCardWidget(
                                        job: job,
                                        onTap: () {
                                          context.push('/job-detail',
                                              extra: job);
                                        },
                                      ),
                                    )),
                              ],
                            );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        Center(child: Text('Error loading jobs: $error')),
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
