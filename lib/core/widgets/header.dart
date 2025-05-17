import 'package:flutter/material.dart';
import 'package:easy_hire/core/widgets/add_bottom_sheet.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({super.key, required this.title});

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const AddBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            height: 45,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 👈 Add Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => _showAddSheet(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF000F50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 45,
                      height: 45,
                      child: const Icon(Icons.add, color: Colors.white, size: 25),
                    ),
                  ),
                ),

                // 📝 Center Title
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // 👤 Profile Picture
                const Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 🔽 Divider below header
        const Divider(
          height: 2,
          thickness: 1,
          color: Color(0xFFE0E0E0),
        ),
      ],
    );
  }
}
