import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderSection({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Center(
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
