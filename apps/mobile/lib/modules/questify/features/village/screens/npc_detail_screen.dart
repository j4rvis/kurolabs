import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/dnd_button.dart';
import '../providers/village_provider.dart';
import '../widgets/quest_template_tile.dart';

class NpcDetailScreen extends ConsumerStatefulWidget {
  const NpcDetailScreen({super.key, required this.npcId});
  final String npcId;

  @override
  ConsumerState<NpcDetailScreen> createState() => _NpcDetailScreenState();
}

class _NpcDetailScreenState extends ConsumerState<NpcDetailScreen> {
  final Set<String> _loadingTemplates = {};
  bool _connectLoading = false;

  Future<void> _toggleConnect(bool isConnected) async {
    setState(() => _connectLoading = true);
    try {
      final notifier = ref.read(villageNotifierProvider.notifier);
      if (isConnected) {
        await notifier.disconnect(widget.npcId);
      } else {
        await notifier.connect(widget.npcId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.waxRed),
        );
      }
    } finally {
      if (mounted) setState(() => _connectLoading = false);
    }
  }

  Future<void> _toggleTemplate(String templateId, bool isAccepted) async {
    setState(() => _loadingTemplates.add(templateId));
    try {
      final notifier = ref.read(villageNotifierProvider.notifier);
      if (isAccepted) {
        await notifier.removeTemplate(widget.npcId, templateId);
      } else {
        await notifier.acceptTemplate(widget.npcId, templateId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.waxRed),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingTemplates.remove(templateId));
    }
  }

  void _showCustomQuestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.parchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _CustomQuestSheet(
        npcId: widget.npcId,
        onCreated: () {
          ref.invalidate(npcDetailProvider(widget.npcId));
          ref.invalidate(villageNpcsProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(npcDetailProvider(widget.npcId));

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detail) {
          final npc = detail['npc'] as Map<String, dynamic>;
          final isConnected = detail['is_connected'] as bool? ?? false;
          final templates = List<Map<String, dynamic>>.from(detail['templates'] as List);
          final customQuests = List<Map<String, dynamic>>.from(detail['custom_quests'] as List);

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
              // Portrait header with back button
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.inkBrown,
                foregroundColor: AppColors.parchment,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/npc/${npc['image_filename']}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.inkBrown),
                      ),
                      // Gradient overlay for readability
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.inkBrown.withAlpha(200),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      // NPC name + title at bottom of header
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B1F6A),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'NPC',
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
                                    npc['name'] as String,
                                    style: AppTextStyles.questTitle.copyWith(
                                      color: AppColors.parchment,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    npc['title'] as String,
                                    style: AppTextStyles.italic.copyWith(
                                      color: AppColors.goldLight,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Connect/disconnect button
                            _connectLoading
                                ? const SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: CircularProgressIndicator(
                                      color: AppColors.goldAccent,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => _toggleConnect(isConnected),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isConnected
                                            ? AppColors.forestGreen
                                            : AppColors.goldAccent.withAlpha(30),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isConnected
                                              ? AppColors.forestGreen
                                              : AppColors.goldAccent,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isConnected ? Icons.check : Icons.add,
                                            size: 14,
                                            color: isConnected
                                                ? Colors.white
                                                : AppColors.goldAccent,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            isConnected ? 'Following' : 'Follow',
                                            style: AppTextStyles.caption.copyWith(
                                              color: isConnected ? Colors.white : AppColors.goldAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category chip + description
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.inkBrown.withAlpha(12),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.parchmentBorder),
                        ),
                        child: Text(
                          npc['category'] as String,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.inkBrownLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        npc['description'] as String,
                        style: AppTextStyles.italic.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              // Quest templates by frequency
              ...byFrequency.entries
                  .where((e) => e.value.isNotEmpty)
                  .map((e) => _FrequencySection(
                        frequency: e.key,
                        templates: e.value,
                        loadingIds: _loadingTemplates,
                        onToggle: _toggleTemplate,
                      )),

              // Custom quests section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'CUSTOM QUESTS',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.goldAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showCustomQuestSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.goldAccent.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.goldAccent.withAlpha(120)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add, size: 14, color: AppColors.goldAccent),
                              const SizedBox(width: 4),
                              Text(
                                'Add Quest',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.goldAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (customQuests.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(
                      'No custom quests yet. Add one to track your own goals under this quest giver.',
                      style: AppTextStyles.italic.copyWith(fontSize: 12, color: AppColors.inkBrownLight),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final q = customQuests[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.parchment,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.parchmentBorder.withAlpha(100)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(q['title'] as String, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                                    Text(
                                      (q['quest_type'] as String).toUpperCase(),
                                      style: AppTextStyles.caption.copyWith(color: AppColors.inkBrownLight, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${q['xp_reward']} XP',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.goldAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: customQuests.length,
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

// ─── Frequency section sliver ────────────────────────────────────────────────

class _FrequencySection extends StatelessWidget {
  const _FrequencySection({
    required this.frequency,
    required this.templates,
    required this.loadingIds,
    required this.onToggle,
  });

  final String frequency;
  final List<Map<String, dynamic>> templates;
  final Set<String> loadingIds;
  final Future<void> Function(String templateId, bool isAccepted) onToggle;

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
            ...templates.map(
              (t) => QuestTemplateTile(
                template: t,
                isLoading: loadingIds.contains(t['id'] as String),
                onToggle: () => onToggle(
                  t['id'] as String,
                  t['accepted_quest_id'] != null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Custom Quest bottom sheet ────────────────────────────────────────────────

class _CustomQuestSheet extends ConsumerStatefulWidget {
  const _CustomQuestSheet({required this.npcId, required this.onCreated});
  final String npcId;
  final VoidCallback onCreated;

  @override
  ConsumerState<_CustomQuestSheet> createState() => _CustomQuestSheetState();
}

class _CustomQuestSheetState extends ConsumerState<_CustomQuestSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _frequency = 'daily';
  String _difficulty = 'easy';
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
      await ref.read(villageNotifierProvider.notifier).createCustomQuest(widget.npcId, {
        'title': _titleController.text.trim(),
        'description': _descController.text.trim().isEmpty ? null : _descController.text.trim(),
        'frequency': _frequency,
        'difficulty': _difficulty,
      });
      widget.onCreated();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.waxRed),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final frequencies = ['daily', 'weekly', 'monthly', 'one_time'];
    final difficulties = ['trivial', 'easy', 'medium', 'hard', 'deadly', 'legendary'];

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
          Text('Add Custom Quest', style: AppTextStyles.questTitle.copyWith(fontSize: 18)),
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
                      decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
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
                      decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                      items: difficulties
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
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
              label: 'Add Quest',
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
