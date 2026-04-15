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

enum ButtonType { primary, secondary, outline, text }

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;

  const MyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    Gradient? getGradient() {
      if (type == ButtonType.primary && !isDisabled && backgroundColor == null) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
        );
      }
      return null;
    }

    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;

      switch (type) {
        case ButtonType.primary:
          return isDisabled
              ? Colors.grey.shade300
              : AppColors.primary;
        case ButtonType.secondary:
          return isDisabled
              ? Colors.grey.shade200
              : Colors.grey.shade100;
        case ButtonType.outline:
          return Colors.transparent;
        case ButtonType.text:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      if (textColor != null) return textColor!;

      switch (type) {
        case ButtonType.primary:
          return Colors.white;
        case ButtonType.secondary:
          return AppColors.textPrimary;
        case ButtonType.outline:
          return AppColors.primary;
        case ButtonType.text:
          return AppColors.primary;
      }
    }

    BorderSide? getBorder() {
      if (type == ButtonType.outline) {
        return BorderSide(
          color: isDisabled ? Colors.grey.shade300 : AppColors.primary,
          width: 1.5,
        );
      }
      return null;
    }

    final gradient = getGradient();

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          border: getBorder() != null
              ? Border.all(
                  color: getBorder()!.color,
                  width: getBorder()!.width,
                )
              : null,
          color: gradient == null ? getBackgroundColor() : null,
          boxShadow: type == ButtonType.primary && !isDisabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(getTextColor()),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 20, color: getTextColor()),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: getTextColor(),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
