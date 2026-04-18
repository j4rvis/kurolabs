import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/services/api_service.dart';
import '../../../shared/widgets/parchment_card.dart';

final _epicsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final data = await ApiService.get('/api/epics');
  return List<Map<String, dynamic>>.from(data['epics'] as List);
});

class EpicsScreen extends ConsumerWidget {
  const EpicsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final epicsAsync = ref.watch(_epicsProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.inkBrown,
        foregroundColor: AppColors.parchment,
        title: Text('Epics', style: AppTextStyles.questTitle.copyWith(color: AppColors.parchment)),
        elevation: 0,
      ),
      body: epicsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (epics) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: epics.length,
          itemBuilder: (context, index) {
            final epic = epics[index];
            final colorHex = epic['color_hex'] as String? ?? '#8B4513';
            final color = Color(int.parse('FF${colorHex.replaceFirst('#', '')}', radix: 16));

            return ParchmentCard(
              accentColor: color,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.auto_stories, color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(epic['name'] as String, style: AppTextStyles.questTitle),
                        if (epic['description'] != null)
                          Text(epic['description'] as String, style: AppTextStyles.italic),
                        const SizedBox(height: 4),
                        Text(
                          'Affects: ${_abilityLabel(epic['ability_score'] as String?)}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  if (epic['is_system'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.inkBrown.withAlpha(20),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text('SYSTEM', style: AppTextStyles.caption.copyWith(fontSize: 9)),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _abilityLabel(String? score) {
    const labels = {
      'str': 'Strength (STR)',
      'dex': 'Dexterity (DEX)',
      'con': 'Constitution (CON)',
      'int_score': 'Intelligence (INT)',
      'wis': 'Wisdom (WIS)',
      'cha': 'Charisma (CHA)',
    };
    return labels[score] ?? score ?? '—';
  }
}
