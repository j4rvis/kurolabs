import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/parchment_card.dart';

class XpProgressBar extends StatelessWidget {
  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.nextLevelXp,
    required this.level,
  });

  final int currentXp;
  final int? nextLevelXp;
  final int level;

  @override
  Widget build(BuildContext context) {
    final hasNextLevel = nextLevelXp != null && nextLevelXp! > 0;
    final progress = hasNextLevel ? (currentXp / nextLevelXp!).clamp(0.0, 1.0) : 1.0;
    final xpToNext = hasNextLevel ? nextLevelXp! - currentXp : 0;

    return ParchmentCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Experience', style: AppTextStyles.sectionHeader),
              const Spacer(),
              Text('$currentXp XP', style: AppTextStyles.xpValue),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              // Background track
              Container(
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.parchmentBorder.withAlpha(80),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: AppColors.parchmentBorder),
                ),
              ),
              // Gold fill
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.goldAccent, AppColors.goldLight],
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('Level $level', style: AppTextStyles.caption),
              const Spacer(),
              if (hasNextLevel)
                Text('$xpToNext XP to Level ${level + 1}', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
