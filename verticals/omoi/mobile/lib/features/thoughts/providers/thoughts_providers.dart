import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/thoughts_repository.dart';

final thoughtsRepositoryProvider = Provider<ThoughtsRepository>((ref) {
  return ThoughtsRepository(Supabase.instance.client);
});

final thoughtListProvider =
    FutureProvider.family<List<Thought>, int>((ref, page) async {
  return ref.read(thoughtsRepositoryProvider).listThoughts(page: page);
});

final thoughtDetailProvider =
    FutureProvider.family<Thought, String>((ref, id) async {
  return ref.read(thoughtsRepositoryProvider).getThought(id);
});

final thoughtConnectionsProvider =
    FutureProvider.family<List<Thought>, String>((ref, thoughtId) async {
  return ref.read(thoughtsRepositoryProvider).getConnections(thoughtId);
});

final thoughtStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.read(thoughtsRepositoryProvider).getStats();
});
