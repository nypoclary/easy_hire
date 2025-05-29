import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color headerBackground = Color(0xFF1C2E74); // Lighter navy blue
  static const Color cardBackground = Colors.white;
  static const Color textColor = Colors.black87;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: headerBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  color: headerBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                bottom: -70,
                left: 0,
                right: 0,
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          AssetImage('assets/images/profile_pic.jpg'),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Nay Zin Ou',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 90),

          // Info Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _infoTile('Username', 'Nay Zin Ou'),
                const SizedBox(height: 24),
                _infoTile('Email', 'nayzinou@gmail.com'),
                const SizedBox(height: 24),
                _infoTile(
                  'About Me',
                  'A short bio about yourself goes here. You can describe your interests, work, or anything you’d like others to know.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoTile(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: textColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
