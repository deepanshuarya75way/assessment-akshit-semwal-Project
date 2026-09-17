import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;
  final IconData icon;

  const EditButton({
    super.key,
    required this.onTap,
    this.text = "Edit",
    this.color = Colors.blue,
    this.icon = Icons.edit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}