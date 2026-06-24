import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ButtonType { solid, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final Widget? icon;
  final double width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.solid,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.icon,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    if (type == ButtonType.solid) {
      bg = backgroundColor ?? theme.primaryColor;
      fg = textColor ?? (bg == AppColors.primaryGreen ? Colors.black : Colors.white);
    } else if (type == ButtonType.outline) {
      bg = Colors.transparent;
      fg = textColor ?? (isDark ? Colors.white : Colors.black);
      border = BorderSide(
        color: backgroundColor ?? (isDark ? AppColors.darkDivider : AppColors.lightDivider),
        width: 1.5,
      );
    } else {
      bg = Colors.transparent;
      fg = textColor ?? theme.primaryColor;
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isLoading || onPressed == null) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: border,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
