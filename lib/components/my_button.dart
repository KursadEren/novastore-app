import 'package:flutter/material.dart';

// Color Palette
class AppColors {
  // Primary Dark
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primaryDarkMid = Color(0xFF1E40AF);
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryMid = Color(0xFF60A5FA);

  // Primary Light
  static const Color secondaryAccent = Color(0xFF93C5FD);
  static const Color secondaryLight = Color(0xFFDBEAFE);
  static const Color primary50 = Color(0xFFEFF6FF);

  // Neutral / Surface
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  // Neutral Dark / Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFFCBD5E1);

  // Semantic / Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const MyButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
