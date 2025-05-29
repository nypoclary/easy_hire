import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_hire/core/provider/location_provider.dart';

class LocationFilterChip extends ConsumerWidget {
  final List<String> locationOptions;

  const LocationFilterChip({
    super.key,
    required this.locationOptions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(locationFilterProvider);

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
              onChanged: (value) {
                if (value != null) {
                  ref.read(locationFilterProvider.notifier).state = value;
                }
              },
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
