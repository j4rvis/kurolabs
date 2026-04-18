import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/xp_constants.dart';
import '../../../shared/widgets/dnd_button.dart';
import '../../../shared/widgets/parchment_card.dart';
import '../providers/quest_provider.dart';

class CreateQuestScreen extends ConsumerStatefulWidget {
  const CreateQuestScreen({super.key, this.questGiverId});
  final String? questGiverId;

  @override
  ConsumerState<CreateQuestScreen> createState() => _CreateQuestScreenState();
}

class _CreateQuestScreenState extends ConsumerState<CreateQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _questType = 'daily';
  String _difficulty = 'medium';
  DateTime? _dueDate;
  bool _isLoading = false;

  static const _questTypes = ['daily', 'side', 'epic'];
  static const _difficulties = ['trivial', 'easy', 'medium', 'hard', 'deadly', 'legendary'];

  bool get _showDueDatePicker => _questType == 'side' || widget.questGiverId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.inkBrown,
            onPrimary: AppColors.parchment,
            surface: AppColors.parchment,
            onSurface: AppColors.inkBrown,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ref
          .read(questsByTypeProvider(_questType).notifier)
          .createQuest({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'quest_type': _questType,
        'difficulty': _difficulty,
        if (widget.questGiverId != null) 'quest_giver_id': widget.questGiverId,
        if (_dueDate != null) 'due_date': _formatDate(_dueDate!),
      });

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final xp = XpConstants.xpByDifficulty[_difficulty] ?? 100;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.inkBrown,
        foregroundColor: AppColors.parchment,
        title: Text('New Quest', style: AppTextStyles.questTitle.copyWith(color: AppColors.parchment)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quest giver banner
              if (widget.questGiverId != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.goldAccent.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: AppColors.goldAccent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Quest assigned by a Quest Giver',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.inkBrown),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ParchmentCard(
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quest Details', style: AppTextStyles.sectionHeader),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      style: AppTextStyles.bodyMedium,
                      decoration: _fieldDecoration('Quest Title'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      style: AppTextStyles.bodyMedium,
                      decoration: _fieldDecoration('Description (optional)'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ParchmentCard(
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quest Type', style: AppTextStyles.sectionHeader),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _questTypes.map((type) {
                        final selected = _questType == type;
                        return ChoiceChip(
                          label: Text(type.toUpperCase()),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            _questType = type;
                            if (type != 'side') _dueDate = null;
                          }),
                          selectedColor: AppColors.inkBrown,
                          backgroundColor: AppColors.parchmentDark,
                          labelStyle: AppTextStyles.caption.copyWith(
                            color: selected ? AppColors.parchment : AppColors.inkBrown,
                            fontWeight: FontWeight.bold,
                          ),
                          side: BorderSide(color: AppColors.parchmentBorder),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ParchmentCard(
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Difficulty', style: AppTextStyles.sectionHeader),
                        const Spacer(),
                        Text('+$xp XP', style: AppTextStyles.xpValue),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _difficulties.map((diff) {
                        final selected = _difficulty == diff;
                        final color = AppColors.forDifficulty(diff);
                        return ChoiceChip(
                          label: Text(XpConstants.difficultyLabels[diff] ?? diff),
                          selected: selected,
                          onSelected: (_) => setState(() => _difficulty = diff),
                          selectedColor: color,
                          backgroundColor: AppColors.parchmentDark,
                          labelStyle: AppTextStyles.caption.copyWith(
                            color: selected ? Colors.white : color,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          side: BorderSide(color: color.withAlpha(100)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Due date picker — shown for side quests or quest-giver quests
              if (_showDueDatePicker) ...[
                const SizedBox(height: 16),
                ParchmentCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Due Date', style: AppTextStyles.sectionHeader),
                      const SizedBox(height: 4),
                      Text(
                        _questType == 'daily'
                            ? 'When must this quest be fulfilled?'
                            : 'Optional deadline for this quest',
                        style: AppTextStyles.italic,
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.parchmentDark,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.parchmentBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: AppColors.inkBrown),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _dueDate != null ? _formatDate(_dueDate!) : 'Tap to set a due date',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: _dueDate != null ? AppColors.inkBrown : AppColors.parchmentBorder,
                                  ),
                                ),
                              ),
                              if (_dueDate != null)
                                GestureDetector(
                                  onTap: () => setState(() => _dueDate = null),
                                  child: const Icon(Icons.clear, size: 16, color: AppColors.parchmentBorder),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              DndButton(
                label: 'Post Quest',
                onPressed: _create,
                isLoading: _isLoading,
                icon: Icons.auto_stories,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.label,
        filled: true,
        fillColor: AppColors.parchmentDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.parchmentBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.parchmentBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.inkBrown, width: 1.5),
        ),
      );
}
