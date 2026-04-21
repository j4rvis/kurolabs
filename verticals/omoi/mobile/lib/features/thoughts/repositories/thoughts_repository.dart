import 'package:supabase_flutter/supabase_flutter.dart';

enum ThoughtCategory { question, reminder, insight, idea, other }

class Thought {
  final String id;
  final String userId;
  final String content;
  final ThoughtCategory category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Thought({
    required this.id,
    required this.userId,
    required this.content,
    required this.category,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Thought.fromJson(Map<String, dynamic> json) => Thought(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        content: json['content'] as String,
        category: ThoughtCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => ThoughtCategory.other,
        ),
        tags: List<String>.from(json['tags'] as List),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}

class ThoughtsRepository {
  final SupabaseClient _client;

  ThoughtsRepository(this._client);

  Future<List<Thought>> listThoughts({int page = 1, int limit = 20}) async {
    final offset = (page - 1) * limit;
    final response = await _client
        .from('thoughts')
        .select()
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
    return (response as List).map((e) => Thought.fromJson(e)).toList();
  }

  Future<Thought> getThought(String id) async {
    final response =
        await _client.from('thoughts').select().eq('id', id).single();
    return Thought.fromJson(response);
  }

  Future<Thought> createThought(String content) async {
    final response = await _client
        .from('thoughts')
        .insert({'content': content})
        .select()
        .single();
    return Thought.fromJson(response);
  }

  Future<Thought> updateThought(String id,
      {String? content, String? category, List<String>? tags}) async {
    final updates = <String, dynamic>{};
    if (content != null) updates['content'] = content;
    if (category != null) updates['category'] = category;
    if (tags != null) updates['tags'] = tags;
    final response = await _client
        .from('thoughts')
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return Thought.fromJson(response);
  }

  Future<void> deleteThought(String id) async {
    await _client.from('thoughts').delete().eq('id', id);
  }

  Future<List<Thought>> getConnections(String thoughtId) async {
    final a = await _client
        .from('thought_connections')
        .select('thought_id_b')
        .eq('thought_id_a', thoughtId);
    final b = await _client
        .from('thought_connections')
        .select('thought_id_a')
        .eq('thought_id_b', thoughtId);
    final ids = [
      ...(a as List).map((e) => e['thought_id_b'] as String),
      ...(b as List).map((e) => e['thought_id_a'] as String),
    ];
    if (ids.isEmpty) return [];
    final response =
        await _client.from('thoughts').select().inFilter('id', ids);
    return (response as List).map((e) => Thought.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getStats() async {
    final user = _client.auth.currentUser;
    if (user == null) return {};

    final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);

    final total = await _client
        .from('thoughts')
        .select('id', const FetchOptions(count: CountOption.exact, head: true));
    final today = await _client
        .from('thoughts')
        .select('id', const FetchOptions(count: CountOption.exact, head: true))
        .gte('created_at', todayStart.toIso8601String());
    final tags = await _client.from('thoughts').select('tags');

    final tagCounts = <String, int>{};
    for (final row in tags as List) {
      for (final tag in (row['tags'] as List)) {
        tagCounts[tag as String] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    final topTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'total': total.count ?? 0,
      'today': today.count ?? 0,
      'top_tags': topTags.take(10).map((e) => {'tag': e.key, 'count': e.value}).toList(),
    };
  }
}
