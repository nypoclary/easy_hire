import 'package:flutter/material.dart';

class CreateJobScreen extends StatelessWidget {
  const CreateJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'Create A Job',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Job Type'),
            _buildTextField(border),

            const SizedBox(height: 20),
            _buildLabel('Education'),
            _buildTextField(border),

            const SizedBox(height: 20),
            _buildLabel('Category'),
            _buildTextField(border),

            const SizedBox(height: 20),
            _buildLabel('Where to work'),
            _buildTextField(border),

            const SizedBox(height: 20),
            _buildLabel('Salary'),
            _buildTextField(border, hintText: '\$10,000 - \$25,000'),

            const SizedBox(height: 20),
            _buildLabel('Job Description'),
            _buildTextField(
              border,
              maxLines: 6,
              hintText:
                  'Google is seeking a talented and passionate UI/UX Designer to join our dynamic team. As a UI/UX Designer at Google, you will play a key role in creating seamless, intuitive, and visually stunning user experiences across our diverse range of products.',
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C1C6B), // Dark navy blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: Handle job creation logic
                },
                child: const Text(
                  'Create Job',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    OutlineInputBorder border, {
    String? hintText,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.black54),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
