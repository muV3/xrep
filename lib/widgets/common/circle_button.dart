import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const CircleButton({
    super.key,
    this.icon,
    this.label,
    required this.onTap,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white10),
        ),
        child: icon != null
            ? IconTheme(
                data: IconThemeData(color: iconColor ?? Colors.white, size: 18),
                child: icon!,
              )
            : Text(
                label ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: iconColor ?? const Color(0xFF38BDF8),
                ),
              ),
      ),
    );
  }
}
