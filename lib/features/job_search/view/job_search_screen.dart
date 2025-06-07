import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:easy_hire/features/home/widgets/location_filter_chip.dart';
import 'package:easy_hire/core/widgets/job_card.dart';
import 'package:easy_hire/core/provider/search_provider.dart';
import 'package:easy_hire/core/provider/location_provider.dart';
import 'package:easy_hire/core/provider/job_provider.dart';

class JobSearchScreen extends ConsumerWidget {
  final String? category;

  const JobSearchScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final selectedLocation = ref.watch(locationFilterProvider);
    final jobAsync = ref.watch(jobListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              title: category != null ? '${_formatTitle(category!)} Jobs' : 'All Jobs',
              hasBackButton: category != null,
              hasAddButton: category == null,
              onBackPressed: () => context.go('/'),
            ),
            const SizedBox(height: 24),
            JobSearchBar(
              onChanged: (query) =>
                  ref.read(searchQueryProvider.notifier).state = query,
            ),
            const SizedBox(height: 20),
            LocationFilterChip(
              locationOptions: [
                'All',
                'Yangon',
                'Mandalay',
                'Naypyitaw',
                'Mawlamyine',
                'Sagaing',
                'Bago'
              ],
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
              child: jobAsync.when(
                data: (jobs) {
                  final filtered = jobs.where((job) {
                    final normalizedCategory = category?.toLowerCase().trim().replaceAll('-', ' ') ?? '';
                    final workMode = job.workMode.toLowerCase().trim().replaceAll('-', ' ');
                    final role = job.role.toLowerCase();
                    final company = job.company.toLowerCase();
                    final tag = job.tag.toLowerCase();
                    final jobType = job.jobType.toLowerCase();
                    final categoryField = job.category.toLowerCase();
                    final location = job.location.toLowerCase();

                    final matchesWorkMode = workMode.contains(normalizedCategory);

                    final matchesSearch = searchQuery.isEmpty ||
                        role.contains(searchQuery) ||
                        company.contains(searchQuery) ||
                        tag.contains(searchQuery) ||
                        jobType.contains(searchQuery) ||
                        workMode.contains(searchQuery) ||
                        categoryField.contains(searchQuery);

                    final matchesLocation = selectedLocation == 'All'
                        ? true
                        : location.contains(selectedLocation.toLowerCase());

                    return matchesWorkMode && matchesSearch && matchesLocation;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text('No ${_formatTitle(category ?? '')} jobs found.'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final job = filtered[index];
                      return JobCardWidget(
                        job: job,
                        onTap: () {
                          context.push('/job-detail', extra: job);
                        },
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text('Error: ${err.toString()}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Capitalizes the first letter of each word (e.g. "part time" → "Part Time")
  String _formatTitle(String input) {
    return input
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}
