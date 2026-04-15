import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/parchment_card.dart';

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.quest,
    required this.onTap,
    required this.onComplete,
  });

  final Map<String, dynamic> quest;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final difficulty = quest['difficulty'] as String? ?? 'medium';
    final questType = quest['quest_type'] as String? ?? 'side';
    final xpReward = quest['xp_reward'] as int? ?? 0;
    final streak = quest['current_streak'] as int? ?? 0;
    final epic = quest['epics'] as Map<String, dynamic>?;
    final questGiverId = quest['quest_giver_id'] as String?;
    final epicColor = epic != null
        ? Color(
            int.parse('FF${(epic['color_hex'] as String).replaceFirst('#', '')}',
                radix: 16))
        : AppColors.forQuestType(questType);

    final isVerified = quest['verified_at'] != null;

    return ParchmentCard(
      accentColor: epicColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  quest['title'] as String? ?? 'Untitled Quest',
                  style: AppTextStyles.questTitle,
                ),
              ),
              const SizedBox(width: 8),
              _DifficultyBadge(difficulty: difficulty),
            ],
          ),
          if (quest['description'] != null &&
              (quest['description'] as String).isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              quest['description'] as String,
              style: AppTextStyles.italic,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              // Epic tag
              if (epic != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: epicColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: epicColor.withAlpha(80)),
                  ),
                  child: Text(
                    epic['name'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: epicColor,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // Quest giver badge
              if (questGiverId != null) ...[
                _GiverBadge(),
                const SizedBox(width: 8),
              ],
              // Streak flame for daily quests
              if (questType == 'daily' && streak > 0) ...[
                const Icon(Icons.local_fire_department,
                    color: AppColors.diffHard, size: 14),
                Text(
                  '$streak',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.diffHard,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (isVerified)
                const Icon(Icons.verified, color: AppColors.forestGreen, size: 14),
              const Spacer(),
              // Timer chip
              _TimerChip(quest: quest),
              const SizedBox(width: 8),
              Text(
                '+$xpReward XP',
                style: AppTextStyles.xpValue,
              ),
              const SizedBox(width: 12),
              // Complete button
              GestureDetector(
                onTap: onComplete,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.inkBrown,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.goldAccent,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GiverBadge extends StatelessWidget {
  const _GiverBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withAlpha(25),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: AppColors.goldAccent.withAlpha(120)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_outline, size: 10, color: AppColors.goldAccent),
          const SizedBox(width: 3),
          Text(
            'ASSIGNED',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({required this.quest});
  final Map<String, dynamic> quest;

  @override
  Widget build(BuildContext context) {
    final questType = quest['quest_type'] as String? ?? 'side';
    final now = DateTime.now();

    DateTime? due;
    if (questType == 'daily') {
      // Daily quests are due at midnight tonight
      due = DateTime(now.year, now.month, now.day + 1);
    } else {
      final dueDateStr = quest['due_date'] as String?;
      if (dueDateStr == null) return const SizedBox.shrink();
      final d = DateTime.parse(dueDateStr);
      // Due at end of the specified day
      due = DateTime(d.year, d.month, d.day + 1);
    }

    final remaining = due.difference(now);

    // Urgency thresholds: daily < 1 hr, weekly/side < 1 day
    final isUrgent = questType == 'daily'
        ? remaining.inMinutes < 60
        : remaining.inHours < 24;

    final color = isUrgent ? AppColors.waxRed : AppColors.inkBrown.withAlpha(140);

    String label;
    if (remaining.isNegative) {
      label = 'OVERDUE';
    } else if (remaining.inDays > 0) {
      label = '${remaining.inDays}d ${remaining.inHours % 24}h';
    } else if (remaining.inHours > 0) {
      label = '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else {
      label = '${remaining.inMinutes}m';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});
  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forDifficulty(difficulty);
    final label = difficulty == 'legendary' ? 'LEG' : difficulty.substring(0, 3).toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
