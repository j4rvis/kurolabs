import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurolabs_auth/kurolabs_auth.dart';

// All NPCs with connection status and quest counts
final villageNpcsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final data = await ApiService.get('/api/village');
  return List<Map<String, dynamic>>.from(data['npcs'] as List);
});

// Detail for a single NPC (templates + user's quests)
final npcDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, npcId) async {
  return Map<String, dynamic>.from(await ApiService.get('/api/village/$npcId/quests') as Map);
});

// Notifier that handles connect/disconnect + quest accept/remove + custom quest creation
class VillageNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> connect(String npcId) async {
    await ApiService.post('/api/village/$npcId/connect', {});
    ref.invalidate(villageNpcsProvider);
    ref.invalidate(npcDetailProvider(npcId));
  }

  Future<void> disconnect(String npcId) async {
    await ApiService.delete('/api/village/$npcId/connect');
    ref.invalidate(villageNpcsProvider);
    ref.invalidate(npcDetailProvider(npcId));
  }

  Future<void> acceptTemplate(String npcId, String templateId) async {
    await ApiService.post('/api/village/$npcId/quests', {
      'template_id': templateId,
      'action': 'accept',
    });
    ref.invalidate(npcDetailProvider(npcId));
    ref.invalidate(villageNpcsProvider);
  }

  Future<void> removeTemplate(String npcId, String templateId) async {
    await ApiService.post('/api/village/$npcId/quests', {
      'template_id': templateId,
      'action': 'remove',
    });
    ref.invalidate(npcDetailProvider(npcId));
    ref.invalidate(villageNpcsProvider);
  }

  Future<void> createCustomQuest(String npcId, Map<String, dynamic> payload) async {
    await ApiService.post('/api/village/$npcId/quests', {
      'is_custom': true,
      ...payload,
    });
    ref.invalidate(npcDetailProvider(npcId));
    ref.invalidate(villageNpcsProvider);
  }
}

final villageNotifierProvider =
    AsyncNotifierProvider<VillageNotifier, void>(VillageNotifier.new);
