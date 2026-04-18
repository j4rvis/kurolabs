import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/services/api_service.dart';
import '../../../shared/widgets/dnd_button.dart';
import '../../../shared/widgets/parchment_card.dart';
import '../providers/quest_provider.dart';

class QuestDetailScreen extends ConsumerStatefulWidget {
  const QuestDetailScreen({super.key, required this.questId});
  final String questId;

  @override
  ConsumerState<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends ConsumerState<QuestDetailScreen> {
  bool _isCompleting = false;
  Map<String, dynamic>? _quest;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuest();
  }

  Future<void> _loadQuest() async {
    try {
      final data = await ApiService.get('/api/quests/${widget.questId}');
      if (mounted) setState(() => _quest = Map<String, dynamic>.from(data['quest'] as Map));
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _complete() async {
    setState(() => _isCompleting = true);
    try {
      final questType = _quest?['quest_type'] as String? ?? 'side';
      final result = await ref
          .read(questsByTypeProvider(questType).notifier)
          .completeQuest(widget.questId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '+${result['xp_earned']} XP earned!'
              '${result['leveled_up'] == true ? ' 🎉 Level Up!' : ''}',
            ),
            backgroundColor: AppColors.forestGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.waxRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.inkBrown,
        foregroundColor: AppColors.parchment,
        title: Text(
          'Quest Details',
          style: AppTextStyles.questTitle.copyWith(color: AppColors.parchment),
        ),
      ),
      body: _error != null
          ? Center(child: Text('Error: $_error', style: AppTextStyles.bodyMedium))
          : _quest == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ParchmentCard(
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _quest!['title'] as String? ?? '',
                              style: AppTextStyles.displayMedium,
                            ),
                            if (_quest!['description'] != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _quest!['description'] as String,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'Difficulty: ${_quest!['difficulty']}',
                                  style: AppTextStyles.label,
                                ),
                                const Spacer(),
                                Text(
                                  '+${_quest!['xp_reward']} XP',
                                  style: AppTextStyles.xpValue,
                                ),
                              ],
                            ),
                            if (_quest!['quest_type'] == 'daily' &&
                                (_quest!['current_streak'] as int? ?? 0) > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.local_fire_department,
                                      color: AppColors.diffHard, size: 16),
                                  Text(
                                    ' ${_quest!['current_streak']} day streak',
                                    style: AppTextStyles.label
                                        .copyWith(color: AppColors.diffHard),
                                  ),
                                ],
                              ),
                            ],
                            // Due date row
                            if (_quest!['due_date'] != null) ...[
                              const SizedBox(height: 8),
                              _DueDateRow(
                                dueDateStr: _quest!['due_date'] as String,
                                questType: _quest!['quest_type'] as String? ?? 'side',
                              ),
                            ] else if (_quest!['quest_type'] == 'daily') ...[
                              const SizedBox(height: 8),
                              _DueDateRow(
                                dueDateStr: null,
                                questType: 'daily',
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Quest giver section
                      if (_quest!['quest_giver'] != null) ...[
                        const SizedBox(height: 16),
                        _QuestGiverSection(
                          questGiver: _quest!['quest_giver'] as Map<String, dynamic>,
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (_quest!['status'] == 'active')
                        DndButton(
                          label: 'Complete Quest',
                          onPressed: _complete,
                          isLoading: _isCompleting,
                          icon: Icons.check_circle_outline,
                          color: AppColors.forestGreen,
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _DueDateRow extends StatelessWidget {
  const _DueDateRow({required this.dueDateStr, required this.questType});
  final String? dueDateStr;
  final String questType;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    DateTime due;
    String label;
    if (questType == 'daily' && dueDateStr == null) {
      due = DateTime(now.year, now.month, now.day + 1);
      label = 'Today';
    } else if (dueDateStr != null) {
      final d = DateTime.parse(dueDateStr!);
      due = DateTime(d.year, d.month, d.day + 1);
      label = dueDateStr!;
    } else {
      return const SizedBox.shrink();
    }

    final remaining = due.difference(now);
    final isUrgent = questType == 'daily'
        ? remaining.inMinutes < 60
        : remaining.inHours < 24;
    final urgentColor = isUrgent ? AppColors.waxRed : AppColors.inkBrown;

    String timeLeft;
    if (remaining.isNegative) {
      timeLeft = 'Overdue!';
    } else if (remaining.inDays > 0) {
      timeLeft = '${remaining.inDays}d ${remaining.inHours % 24}h remaining';
    } else if (remaining.inHours > 0) {
      timeLeft = '${remaining.inHours}h ${remaining.inMinutes % 60}m remaining';
    } else {
      timeLeft = '${remaining.inMinutes}m remaining';
    }

    return Row(
      children: [
        Icon(Icons.timer_outlined, size: 14, color: urgentColor),
        const SizedBox(width: 4),
        Text(
          'Due: $label  •  $timeLeft',
          style: AppTextStyles.label.copyWith(color: urgentColor),
        ),
      ],
    );
  }
}

class _QuestGiverSection extends StatelessWidget {
  const _QuestGiverSection({required this.questGiver});
  final Map<String, dynamic> questGiver;

  @override
  Widget build(BuildContext context) {
    return ParchmentCard(
      margin: EdgeInsets.zero,
      accentColor: AppColors.goldAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assigned By', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.inkBrown,
                radius: 18,
                child: const Icon(Icons.person, color: AppColors.parchment, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quest Giver', style: AppTextStyles.bodySmall),
                    Text(
                      questGiver['giver_user_id'] as String? ?? '',
                      style: AppTextStyles.caption,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push('/quest-givers'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View Givers',
                  style: AppTextStyles.label.copyWith(color: AppColors.goldAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
