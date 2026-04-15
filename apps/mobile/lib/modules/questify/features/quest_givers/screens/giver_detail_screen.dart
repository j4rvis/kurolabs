import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/dnd_button.dart';
import '../providers/giver_detail_provider.dart';
import '../../village/widgets/quest_template_tile.dart';

class GiverDetailScreen extends ConsumerStatefulWidget {
  const GiverDetailScreen({super.key, required this.relationshipId});
  final String relationshipId;

  @override
  ConsumerState<GiverDetailScreen> createState() => _GiverDetailScreenState();
}

class _GiverDetailScreenState extends ConsumerState<GiverDetailScreen> {
  final Set<String> _loadingTemplates = {};

  Future<void> _toggleTemplate(
      String templateId, bool isAccepted) async {
    setState(() => _loadingTemplates.add(templateId));
    try {
      final notifier = ref.read(giverDetailNotifierProvider.notifier);
      if (isAccepted) {
        await notifier.removeTemplate(widget.relationshipId, templateId);
      } else {
        await notifier.acceptTemplate(widget.relationshipId, templateId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.waxRed),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingTemplates.remove(templateId));
    }
  }

  Future<void> _deleteTemplate(String templateId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.parchment,
        title: Text('Delete Template', style: AppTextStyles.questTitle.copyWith(fontSize: 18)),
        content: const Text(
            'This will remove the template and archive any active quests linked to it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Delete', style: TextStyle(color: AppColors.waxRed)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _loadingTemplates.add(templateId));
    try {
      await ref
          .read(giverDetailNotifierProvider.notifier)
          .deleteTemplate(widget.relationshipId, templateId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.waxRed),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingTemplates.remove(templateId));
    }
  }

  void _showAddTemplateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.parchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AddTemplateSheet(
        relationshipId: widget.relationshipId,
        onCreated: () => ref.invalidate(giverDetailProvider(widget.relationshipId)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(giverDetailProvider(widget.relationshipId));

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detail) {
          final isGiver = detail['is_giver'] as bool? ?? false;
          final giverProfile = detail['giver_profile'] as Map<String, dynamic>?;
          final adventurerProfile = detail['adventurer_profile'] as Map<String, dynamic>?;
          final templates =
              List<Map<String, dynamic>>.from(detail['templates'] as List);

          final displayName = isGiver
              ? (adventurerProfile?['display_name'] as String? ??
                  adventurerProfile?['username'] as String? ??
                  'Adventurer')
              : (giverProfile?['display_name'] as String? ??
                  giverProfile?['username'] as String? ??
                  'Quest Giver');

          final byFrequency = <String, List<Map<String, dynamic>>>{
            'daily': [],
            'weekly': [],
            'monthly': [],
            'one_time': [],
          };
          for (final t in templates) {
            byFrequency[t['frequency'] as String]?.add(t);
          }

          return CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.inkBrown,
                foregroundColor: AppColors.parchment,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppColors.inkBrown,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.goldAccent.withAlpha(40),
                          child: const Icon(
                            Icons.person,
                            size: 52,
                            color: AppColors.goldAccent,
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B1F6A),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isGiver ? 'YOUR ADVENTURER' : 'QUEST GIVER',
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                displayName,
                                style: AppTextStyles.questTitle.copyWith(
                                  color: AppColors.parchment,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Context label ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    isGiver
                        ? 'Define quest templates for your adventurer. They can subscribe to individual quests from your catalog.'
                        : 'Browse quest templates offered by your quest giver. Subscribe to the ones you want to track.',
                    style: AppTextStyles.italic.copyWith(fontSize: 13),
                  ),
                ),
              ),

              // ── Templates by frequency ──────────────────────────────────
              if (templates.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Center(
                      child: Text(
                        isGiver
                            ? 'No templates yet. Add one below.'
                            : 'Your quest giver has not defined any quest templates yet.',
                        style: AppTextStyles.italic.copyWith(
                            fontSize: 13, color: AppColors.inkBrownLight),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                ...byFrequency.entries
                    .where((e) => e.value.isNotEmpty)
                    .map((e) => _FrequencySection(
                          frequency: e.key,
                          templates: e.value,
                          loadingIds: _loadingTemplates,
                          isGiver: isGiver,
                          onToggle: _toggleTemplate,
                          onDelete: _deleteTemplate,
                        )),

              // ── Giver: Add Template button ──────────────────────────────
              if (isGiver)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: DndButton(
                      label: 'Add Quest Template',
                      icon: Icons.add,
                      onPressed: () => _showAddTemplateSheet(context),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

// ─── Frequency section ────────────────────────────────────────────────────────

class _FrequencySection extends StatelessWidget {
  const _FrequencySection({
    required this.frequency,
    required this.templates,
    required this.loadingIds,
    required this.isGiver,
    required this.onToggle,
    required this.onDelete,
  });

  final String frequency;
  final List<Map<String, dynamic>> templates;
  final Set<String> loadingIds;
  final bool isGiver;
  final Future<void> Function(String templateId, bool isAccepted) onToggle;
  final Future<void> Function(String templateId) onDelete;

  static const _labels = {
    'daily': 'DAILY',
    'weekly': 'WEEKLY',
    'monthly': 'MONTHLY',
    'one_time': 'ONE-TIME',
  };

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _labels[frequency] ?? frequency.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.inkBrownLight,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            ...templates.map((t) {
              final templateId = t['id'] as String;
              final isAccepted = t['accepted_quest_id'] != null;
              final isLoading = loadingIds.contains(templateId);

              if (isGiver) {
                // Giver view: show delete icon, no subscribe toggle
                return _GiverTemplateTile(
                  template: t,
                  isLoading: isLoading,
                  onDelete: () => onDelete(templateId),
                );
              }

              // Adventurer view: reuse QuestTemplateTile (subscribe toggle)
              return QuestTemplateTile(
                template: t,
                isLoading: isLoading,
                onToggle: () => onToggle(templateId, isAccepted),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Giver template tile (manage-mode tile for the giver) ────────────────────

class _GiverTemplateTile extends StatelessWidget {
  const _GiverTemplateTile({
    required this.template,
    required this.isLoading,
    required this.onDelete,
  });

  final Map<String, dynamic> template;
  final bool isLoading;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final difficulty = template['difficulty'] as String? ?? 'easy';
    final xp = template['xp_reward'] as int? ?? 50;
    final diffColor = AppColors.forDifficulty(difficulty);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.parchmentBorder.withAlpha(100)),
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
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.w600),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
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
                  onTap: onDelete,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.waxRed.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                      border:
                          Border.all(color: AppColors.waxRed.withAlpha(100)),
                    ),
                    child: const Icon(Icons.delete_outline,
                        size: 16, color: AppColors.waxRed),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Add Template bottom sheet (giver only) ───────────────────────────────────

class _AddTemplateSheet extends ConsumerStatefulWidget {
  const _AddTemplateSheet(
      {required this.relationshipId, required this.onCreated});
  final String relationshipId;
  final VoidCallback onCreated;

  @override
  ConsumerState<_AddTemplateSheet> createState() => _AddTemplateSheetState();
}

class _AddTemplateSheetState extends ConsumerState<_AddTemplateSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _frequency = 'daily';
  String _difficulty = 'medium';
  bool _loading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _loading = true);
    try {
      await ref.read(giverDetailNotifierProvider.notifier).createTemplate(
        widget.relationshipId,
        {
          'title': _titleController.text.trim(),
          'description': _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          'frequency': _frequency,
          'difficulty': _difficulty,
        },
      );
      widget.onCreated();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.waxRed),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const frequencies = ['daily', 'weekly', 'monthly', 'one_time'];
    const difficulties = [
      'trivial', 'easy', 'medium', 'hard', 'deadly', 'legendary'
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Quest Template',
              style: AppTextStyles.questTitle.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Quest title',
              border: OutlineInputBorder(),
            ),
            maxLength: 200,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Frequency', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: _frequency,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), isDense: true),
                      items: frequencies
                          .map((f) => DropdownMenuItem(
                                value: f,
                                child: Text(f.replaceAll('_', '-')),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _frequency = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Difficulty', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: _difficulty,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), isDense: true),
                      items: difficulties
                          .map((d) =>
                              DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) => setState(() => _difficulty = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: DndButton(
              label: 'Add Template',
              isLoading: _loading,
              onPressed: _submit,
              icon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
