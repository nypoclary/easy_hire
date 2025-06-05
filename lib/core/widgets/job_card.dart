import 'package:flutter/material.dart';
import 'package:easy_hire/core/models/job_model.dart';

class JobCardWidget extends StatefulWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCardWidget({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  State<JobCardWidget> createState() => _JobCardWidgetState();
}

class _JobCardWidgetState extends State<JobCardWidget> {
  bool isPressed = false;
  bool isProfilePressed = false;

  void _handleTapDown(_) => setState(() => isPressed = true);
  void _handleTapUp(_) => setState(() => isPressed = false);
  void _handleTapCancel() => setState(() => isPressed = false);

  void _handleProfileTapDown(_) => setState(() => isProfilePressed = true);
  void _handleProfileTapUp(_) => setState(() => isProfilePressed = false);
  void _handleProfileTapCancel() => setState(() => isProfilePressed = false);

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6FF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFA993FF), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isPressed ? 0.15 : 0.05),
              offset: Offset(0, isPressed ? 6 : 2),
              blurRadius: isPressed ? 16 : 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              children: [
                GestureDetector(
                  onTapDown: _handleProfileTapDown,
                  onTapUp: _handleProfileTapUp,
                  onTapCancel: _handleProfileTapCancel,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(isProfilePressed ? 0.2 : 0.05),
                          offset: Offset(0, isProfilePressed ? 6 : 2),
                          blurRadius: isProfilePressed ? 10 : 4,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: job.imageUrl.isNotEmpty
                          ? Image.network(
                              job.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.person),
                            )
                          : const Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.role,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF2A1258))),
                      const SizedBox(height: 4),
                      Text(
                        '${job.company}, ${job.location}',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            // Salary
            RichText(
              text: TextSpan(
                text: job.salary,
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

            // Tags Row with Expanded to match original
            Row(
              children: [
                Expanded(child: _buildTagChip(job.tag)),
                Expanded(child: _buildTagChip(job.type)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    final lower = label.toLowerCase();
    Color backgroundColor;
    Color textColor;

    if (lower.contains('remote')) {
      backgroundColor = const Color(0xFFFFE4D6);
      textColor = const Color(0xFFDE6E35);
    } else if (lower.contains('full')) {
      backgroundColor = const Color(0xFFE0F0FF);
      textColor = const Color(0xFF005DAA);
    } else if (lower.contains('part')) {
      backgroundColor = const Color(0xFFD6F5E8);
      textColor = const Color(0xFF1C8B5F);
    } else {
      backgroundColor = const Color(0xFFEFEBFF);
      textColor = Colors.black;
    }

    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        label.trim(),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: textColor,
        ),
      ),
    );
  }
}
