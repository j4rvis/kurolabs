import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurolabs_auth/kurolabs_auth.dart';

/// Detail for a single giver↔adventurer relationship:
/// templates with accepted_quest_id, giver/adventurer profiles, etc.
final giverDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, relationshipId) async {
  return Map<String, dynamic>.from(
    await ApiService.get('/api/quest-givers/$relationshipId/templates') as Map,
  );
});

/// Notifier that handles template subscribe/unsubscribe and giver-side CRUD.
class GiverDetailNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> acceptTemplate(String relationshipId, String templateId) async {
    await ApiService.post('/api/quest-givers/$relationshipId/templates', {
      'template_id': templateId,
      'action': 'accept',
    });
    ref.invalidate(giverDetailProvider(relationshipId));
  }

  Future<void> removeTemplate(String relationshipId, String templateId) async {
    await ApiService.post('/api/quest-givers/$relationshipId/templates', {
      'template_id': templateId,
      'action': 'remove',
    });
    ref.invalidate(giverDetailProvider(relationshipId));
  }

  Future<void> createTemplate(
      String relationshipId, Map<String, dynamic> payload) async {
    await ApiService.post('/api/quest-givers/$relationshipId/templates', {
      'is_create': true,
      ...payload,
    });
    ref.invalidate(giverDetailProvider(relationshipId));
  }

  Future<void> deleteTemplate(String relationshipId, String templateId) async {
    await ApiService.post('/api/quest-givers/$relationshipId/templates', {
      'is_delete': true,
      'template_id': templateId,
    });
    ref.invalidate(giverDetailProvider(relationshipId));
  }
}

final giverDetailNotifierProvider =
    AsyncNotifierProvider<GiverDetailNotifier, void>(GiverDetailNotifier.new);
