import 'package:flutter/material.dart';

class LocationFilterChip extends StatelessWidget {
  final String selectedLocation;
  final List<String> locationOptions;
  final ValueChanged<String?> onChanged;

  const LocationFilterChip({
    super.key,
    required this.selectedLocation,
    required this.locationOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 32),
        child: Container(
          height: 35,
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xF0F1ECFE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLocation,
              isDense: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 20),
              items: locationOptions.map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: onChanged,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}