import 'package:easy_hire/core/provider/google_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(0xFFBCCEF4),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top full-width image with rounded bottom corners
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                'assets/images/easyhire.jpg', // Replace with actual image
                width: double.infinity,
                height: 530,
                fit: BoxFit.cover,
              ),
            ),

            // const SizedBox(height: 32),

            // Title & subtitle (left-aligned)
            SizedBox(
              width: 350,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Find Jobs Easily\nwith ',
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'EasyHire',
                            style: GoogleFonts.poppins(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 65, 79, 141),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      'Turning Hope into Opportunity.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // const SizedBox(height: 50),

            // Google Sign-in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/images/google_icon.jpg',
                    height: 24,
                    width: 24,
                    errorBuilder: (_, __, ___) => const Icon(Icons.login),
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                        color: Color.fromARGB(255, 22, 106, 180)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ref.read(googleAuthProvider.notifier).signIn();
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
