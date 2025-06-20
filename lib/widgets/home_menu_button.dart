import 'package:flutter/material.dart';

class HomeMenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final String imageAsset;
  final VoidCallback onTap;

  const HomeMenuButton({
    super.key,
    required this.title,
    required this.icon,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 120,
          height: 140,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.deepPurple.shade50,
                child: Icon(icon, size: 36, color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
