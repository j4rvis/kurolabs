import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/parchment_card.dart';
import '../providers/character_provider.dart';
import '../widgets/ability_score_box.dart';
import '../widgets/xp_progress_bar.dart';

class CharacterSheetScreen extends ConsumerWidget {
  const CharacterSheetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.inkBrown,
        foregroundColor: AppColors.parchment,
        title: Text('Character Sheet', style: AppTextStyles.questTitle.copyWith(color: AppColors.parchment)),
        elevation: 0,
      ),
      body: characterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e', style: AppTextStyles.bodyMedium)),
        data: (data) {
          if (data == null) return const Center(child: Text('No character found'));
          return _CharacterSheetBody(data: data);
        },
      ),
    );
  }
}

class _CharacterSheetBody extends StatelessWidget {
  const _CharacterSheetBody({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final character = data['character'] as Map<String, dynamic>;
    final profile = data['profile'] as Map<String, dynamic>?;
    final currentTitle = data['current_title'] as String?;
    final nextLevelXp = data['next_level_xp'] as int?;
    final recentCompletions = data['recent_completions'] as List<dynamic>? ?? [];

    final level = character['level'] as int;
    final totalXp = character['total_xp'] as int;
    final displayName = profile?['display_name'] as String? ??
        profile?['username'] as String? ?? 'Adventurer';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character header
          ParchmentCard(
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.inkBrown,
                  child: Text(
                    displayName[0].toUpperCase(),
                    style: AppTextStyles.displayMedium.copyWith(color: AppColors.goldAccent),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: AppTextStyles.questTitle),
                      Text(currentTitle ?? 'Adventurer', style: AppTextStyles.italic),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.inkBrown,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'Level $level',
                          style: AppTextStyles.levelBadge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // XP Progress
          XpProgressBar(
            currentXp: totalXp,
            nextLevelXp: nextLevelXp,
            level: level,
          ),
          const SizedBox(height: 16),

          // Ability Scores
          ParchmentCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ABILITY SCORES', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  children: [
                    AbilityScoreBox(label: 'STR', score: character['str'] as int),
                    AbilityScoreBox(label: 'DEX', score: character['dex'] as int),
                    AbilityScoreBox(label: 'CON', score: character['con'] as int),
                    AbilityScoreBox(label: 'INT', score: character['int_score'] as int),
                    AbilityScoreBox(label: 'WIS', score: character['wis'] as int),
                    AbilityScoreBox(label: 'CHA', score: character['cha'] as int),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recent Completions
          if (recentCompletions.isNotEmpty) ...[
            Text('RECENT DEEDS', style: AppTextStyles.sectionHeader),
            const SizedBox(height: 8),
            ...recentCompletions.take(5).map((c) {
              final completion = c as Map<String, dynamic>;
              final quest = completion['quests'] as Map<String, dynamic>?;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ParchmentCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          quest?['title'] as String? ?? 'Unknown Quest',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      Text(
                        '+${completion['xp_earned']} XP',
                        style: AppTextStyles.xpValue.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
