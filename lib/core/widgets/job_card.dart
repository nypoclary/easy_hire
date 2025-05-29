import 'package:flutter/material.dart';



class JobCardWidget extends StatefulWidget {
  final String role;
  final String company;
  final String salary;
  final String location;
  final List<String> tags;
  final String imageAsset;
  final VoidCallback onTap;



  const JobCardWidget({
    super.key,
    required this.role,
    required this.company,
    required this.salary,
    required this.tags,
    required this.imageAsset,
    required this.onTap,
    required this.location,
  
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
          border: Border.all(color: Color(0xFFA993FF), width: 2),
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
                          child: Image.asset(
                            widget.imageAsset,
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
                          Text(widget.role,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF2A1258))),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.company}, ${widget.location}',
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
                    text: widget.salary,
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
                  children: widget.tags.map((tag) {
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
          ],
        ),
      ),
    );
  }
}
 