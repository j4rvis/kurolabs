import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class QuestTemplateTile extends StatelessWidget {
  const QuestTemplateTile({
    super.key,
    required this.template,
    required this.onToggle,
    required this.isLoading,
  });

  final Map<String, dynamic> template;
  final VoidCallback onToggle;
  final bool isLoading;


  @override
  Widget build(BuildContext context) {
    final isAccepted = template['accepted_quest_id'] != null;
    final difficulty = template['difficulty'] as String? ?? 'easy';
    final xp = template['xp_reward'] as int? ?? 50;
    final diffColor = AppColors.forDifficulty(difficulty);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAccepted
            ? AppColors.forestGreen.withAlpha(18)
            : AppColors.parchment,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isAccepted
              ? AppColors.forestGreen.withAlpha(120)
              : AppColors.parchmentBorder.withAlpha(100),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template['title'] as String,
                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                ),
                if ((template['description'] as String?)?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    template['description'] as String,
                    style: AppTextStyles.italic.copyWith(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: diffColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: diffColor.withAlpha(100)),
                      ),
                      child: Text(
                        difficulty.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: diffColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$xp XP',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.goldAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          isLoading
              ? const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isAccepted ? AppColors.forestGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isAccepted ? AppColors.forestGreen : AppColors.parchmentBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isAccepted ? Icons.check : Icons.add,
                      size: 18,
                      color: isAccepted ? Colors.white : AppColors.inkBrownLight,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
