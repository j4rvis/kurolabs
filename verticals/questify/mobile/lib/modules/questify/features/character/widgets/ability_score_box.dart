import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/xp_constants.dart';

class AbilityScoreBox extends StatelessWidget {
  const AbilityScoreBox({super.key, required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final modifier = XpConstants.modifier(score);
    final modifierText = modifier >= 0 ? '+$modifier' : '$modifier';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.parchmentDark,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.parchmentBorder, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.statLabel),
          const SizedBox(height: 4),
          Text(modifierText, style: AppTextStyles.statModifier),
          Text('$score', style: AppTextStyles.statScore),
        ],
      ),
    );
  }
}
