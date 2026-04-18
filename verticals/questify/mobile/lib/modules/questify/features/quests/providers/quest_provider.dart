import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurolabs_auth/kurolabs_auth.dart';

/// Provides a list of quests by type (daily / side / epic).
final questsByTypeProvider = AsyncNotifierProviderFamily<
    QuestsByTypeNotifier, List<Map<String, dynamic>>, String>(
  QuestsByTypeNotifier.new,
);

class QuestsByTypeNotifier
    extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
  @override
  Future<List<Map<String, dynamic>>> build(String type) async {
    final data = await ApiService.get(
      '/api/quests',
      queryParams: {'type': type, 'status': 'active'},
    );
    return List<Map<String, dynamic>>.from(data['quests'] as List);
  }

  Future<Map<String, dynamic>> completeQuest(String questId, {String? notes}) async {
    final result = await ApiService.post(
      '/api/quests/$questId/complete',
      {if (notes != null) 'notes': notes},
    );
    ref.invalidateSelf();
    return Map<String, dynamic>.from(result as Map);
  }

  Future<void> createQuest(Map<String, dynamic> questData) async {
    await ApiService.post('/api/quests', questData);
    ref.invalidateSelf();
  }

  Future<void> archiveQuest(String questId) async {
    await ApiService.patch('/api/quests/$questId', {'status': 'archived'});
    ref.invalidateSelf();
  }
}
