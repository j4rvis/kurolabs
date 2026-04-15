import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class DndButton extends StatelessWidget {
  const DndButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? (isPrimary ? AppColors.inkBrown : AppColors.parchmentBorder);
    final fgColor = isPrimary ? AppColors.parchment : AppColors.inkBrown;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isPrimary ? AppColors.goldAccent.withAlpha(100) : AppColors.parchmentBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              offset: const Offset(1, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isLoading || onPressed == null) ? null : onPressed,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: fgColor, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: AppTextStyles.button.copyWith(color: fgColor),
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
