import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/services/api_service.dart';
import '../../../shared/widgets/dnd_button.dart';
import '../../../shared/widgets/parchment_card.dart';

final _questGiversProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final data = await ApiService.get('/api/quest-givers');
  return Map<String, dynamic>.from(data as Map);
});

class QuestGiversScreen extends ConsumerWidget {
  const QuestGiversScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(_questGiversProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.inkBrown,
        foregroundColor: AppColors.parchment,
        title: Text('Quest Givers',
            style:
                AppTextStyles.questTitle.copyWith(color: AppColors.parchment)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: AppColors.goldAccent),
            onPressed: () => context.push('/quest-givers/invite'),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final givers = List<Map<String, dynamic>>.from(
              data['quest_givers'] as List? ?? []);
          final adventurers = List<Map<String, dynamic>>.from(
              data['my_adventurers'] as List? ?? []);

          if (givers.isEmpty && adventurers.isEmpty) {
            return _EmptyState(
                onInvite: () => context.push('/quest-givers/invite'));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              // ── My Quest Givers ──────────────────────────────────────
              if (givers.isNotEmpty) ...[
                _SectionHeader(label: 'MY QUEST GIVERS'),
                ...givers.map((g) => _GiverCard(
                      giver: g,
                      onViewQuests: g['status'] == 'accepted'
                          ? () => context.push('/quest-givers/${g['id']}/detail')
                          : null,
                    )),
              ],

              // ── My Adventurers (when I am a giver) ──────────────────
              if (adventurers.isNotEmpty) ...[
                _SectionHeader(label: 'MY ADVENTURERS'),
                ...adventurers.map((a) => _AdventurerCard(
                      adventurer: a,
                      onManageQuests: () =>
                          context.push('/quest-givers/${a['id']}/detail'),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.goldAccent,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─── Giver card (adventurer's view of their quest givers) ─────────────────────

class _GiverCard extends StatelessWidget {
  const _GiverCard({required this.giver, this.onViewQuests});
  final Map<String, dynamic> giver;
  final VoidCallback? onViewQuests;

  @override
  Widget build(BuildContext context) {
    final status = giver['status'] as String;
    final statusColor = switch (status) {
      'accepted' => AppColors.forestGreen,
      'pending' => AppColors.warning,
      'declined' => AppColors.waxRed,
      _ => AppColors.parchmentBorder,
    };

    return ParchmentCard(
      accentColor: statusColor,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.inkBrown,
            radius: 20,
            child:
                const Icon(Icons.person, color: AppColors.parchment, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(giver['giver_user_id'] as String,
                    style: AppTextStyles.bodySmall),
                Text('Quest Giver', style: AppTextStyles.italic),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(30),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              status.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
          if (onViewQuests != null) ...[
            const SizedBox(width: 8),
            Tooltip(
              message: 'Browse quests from this giver',
              child: IconButton(
                icon: const Icon(Icons.auto_stories,
                    color: AppColors.goldAccent),
                onPressed: onViewQuests,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
                iconSize: 22,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Adventurer card (giver's view of their adventurers) ─────────────────────

class _AdventurerCard extends StatelessWidget {
  const _AdventurerCard(
      {required this.adventurer, required this.onManageQuests});
  final Map<String, dynamic> adventurer;
  final VoidCallback onManageQuests;

  @override
  Widget build(BuildContext context) {
    return ParchmentCard(
      accentColor: AppColors.forestGreen,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.forestGreen.withAlpha(40),
            radius: 20,
            child: const Icon(Icons.shield, color: AppColors.forestGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(adventurer['user_id'] as String,
                    style: AppTextStyles.bodySmall),
                Text('Your Adventurer', style: AppTextStyles.italic),
              ],
            ),
          ),
          Tooltip(
            message: 'Manage quest templates',
            child: IconButton(
              icon: const Icon(Icons.edit_note, color: AppColors.goldAccent),
              onPressed: onManageQuests,
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 32, minHeight: 32),
              iconSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onInvite});
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline,
              size: 64, color: AppColors.parchmentBorder),
          const SizedBox(height: 16),
          Text('No Quest Givers Yet', style: AppTextStyles.questTitle),
          const SizedBox(height: 8),
          Text(
            'Invite a partner or friend to assign quests and verify your deeds.',
            style: AppTextStyles.italic,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          DndButton(
            label: 'Invite a Quest Giver',
            onPressed: onInvite,
            icon: Icons.person_add,
          ),
        ],
      ),
    );
  }
}
