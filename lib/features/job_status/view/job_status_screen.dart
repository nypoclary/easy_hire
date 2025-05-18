import 'package:easy_hire/core/widgets/header.dart';
import 'package:easy_hire/core/widgets/job_search_bar.dart';
import 'package:flutter/material.dart';

enum JobStatus { accepted, pending, rejected }

class JobStatusScreen extends StatefulWidget {
  const JobStatusScreen({super.key});

  @override
  State<JobStatusScreen> createState() => _JobStatusScreenState();
}

class _JobStatusScreenState extends State<JobStatusScreen> {
  bool isPressed = false;
  bool isProfilePressed = false;

  void handleTapDown() => setState(() => isPressed = true);
  void handleTapUp() => setState(() => isPressed = false);
  void _handleTapCancel() => setState(() => isPressed = false);

  void handleProfileTapDown() => setState(() => isProfilePressed = true);
  void handleProfileTapUp() => setState(() => isProfilePressed = false);
  void _handleProfileTapCancel() => setState(() => isProfilePressed = false);

  Color getBorderColor(JobStatus status) {
    switch (status) {
      case JobStatus.accepted:
        return Colors.green;
      case JobStatus.pending:
        return Colors.amber;
      case JobStatus.rejected:
        return Colors.red;
    }
  }

  Color getStatusBgColor(JobStatus status) {
    switch (status) {
      case JobStatus.accepted:
        return Colors.green.shade100;
      case JobStatus.pending:
        return Colors.amber.shade100;
      case JobStatus.rejected:
        return Colors.red.shade100;
    }
  }

  Color getStatusTextColor(JobStatus status) {
    switch (status) {
      case JobStatus.accepted:
        return Colors.green.shade800;
      case JobStatus.pending:
        return Colors.orange.shade800;
      case JobStatus.rejected:
        return Colors.red.shade800;
    }
  }

  String getStatusText(JobStatus status) {
    switch (status) {
      case JobStatus.accepted:
        return 'accepted';
      case JobStatus.pending:
        return 'pending';
      case JobStatus.rejected:
        return 'rejected';
    }
  }

  Widget buildJobCard({
    required String role,
    required String company,
    required String salary,
    required List<String> tags,
    required String imageAsset,
    required JobStatus status,
  }) {
    return GestureDetector(
      onTap: () => debugPrint('Card tapped'),
      // onTapDown: _handleTapDown,
      // onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6FF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: getBorderColor(status), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isPressed ? 0.15 : 0.05),
              offset: Offset(0, isPressed ? 6 : 2),
              blurRadius: isPressed ? 16 : 6,
            ),
          ],
        ),
        child: Stack(
          children: [
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => debugPrint('✅ Profile tapped'),
                  // onTapDown: _handleProfileTapDown,
                  // onTapUp: _handleProfileTapUp,
                  onTapCancel: _handleProfileTapCancel,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              isProfilePressed ? 0.2 : 0.05),
                          offset: Offset(0, isProfilePressed ? 6 : 2),
                          blurRadius: isProfilePressed ? 10 : 4,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(role,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF2A1258))),
                      const SizedBox(height: 4),
                      Text(
                        company,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: salary,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9333EA),
                ),
                children: const [
                  TextSpan(
                    text: '/Mo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: tags.map((tag) {
                final isRemote = tag.toLowerCase() == 'remote';
                final isService = tag.toLowerCase().contains('service');
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: isRemote
                          ? const Color(0xFFFFE4D6)
                          : (isService
                          ? const Color(0xFFEFEBFF)
                          : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isRemote
                            ? const Color(0xFFDE6E35)
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.only(top: 8, right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: getStatusBgColor(status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                getStatusText(status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: getStatusTextColor(status),
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Header(title: 'Applied Job Status'),
            SizedBox(height: 24),
            JobSearchBar(
              onChanged: (query) {
                //  Add search/filter logic here
                print("Search input: $query");
              },
            ),
            SizedBox(height: 8),
            buildJobCard(
              role: 'Product Designer',
              company: 'Google inc  California, USA',
              salary: '\$15K',
              tags: ['Home Service', 'Remote'],
              imageAsset: 'assets/images/profile_pic.jpg',
              status: JobStatus.accepted,
            ),
            buildJobCard(
              role: 'Mobile Dev',
              company: 'Apple  California, USA',
              salary: '\$14K',
              tags: ['Flutter', 'Remote'],
              imageAsset: 'assets/images/profile_pic.jpg',
              status: JobStatus.pending,
            ),
            buildJobCard(
              role: 'Product Designer',
              company: 'Google inc  California, USA',
              salary: '\$15K',
              tags: ['Home Service', 'Remote'],
              imageAsset: 'assets/images/profile_pic.jpg',
              status: JobStatus.accepted,
            ),
            buildJobCard(
              role: 'Mobile Dev',
              company: 'Apple  California, USA',
              salary: '\$14K',
              tags: ['Flutter', 'Remote'],
              imageAsset: 'assets/images/profile_pic.jpg',
              status: JobStatus.pending,
            ),
          ],
        ),
      ),
    );
  }
}

