import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ParchmentCard extends StatelessWidget {
  const ParchmentCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderColor,
    this.onTap,
    this.accentColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final VoidCallback? onTap;

  /// Optional left-edge accent stripe (for epic/quest type coloring).
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAEED8),
            AppColors.parchment,
            AppColors.parchmentDark,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: borderColor ?? AppColors.parchmentBorder,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            offset: Offset(2, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (accentColor != null)
                Container(width: 4, color: accentColor),
              Expanded(
                child: onTap != null
                    ? InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(5),
                        child: Padding(
                          padding: padding ?? const EdgeInsets.all(16),
                          child: child,
                        ),
                      )
                    : Padding(
                        padding: padding ?? const EdgeInsets.all(16),
                        child: child,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
