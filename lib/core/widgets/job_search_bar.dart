import 'package:flutter/material.dart';
import 'package:easy_hire/core/app_theme.dart';

class JobSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final double height;
  final double? width;

  const JobSearchBar({
    super.key,
    this.onChanged,
    this.height = 45,
    this.width = 340,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.primaryNavyBlue.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: onChanged,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'Search For Jobs',
              hintStyle: const TextStyle(color: Colors.black45),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.search, color: AppTheme.primaryNavyBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}