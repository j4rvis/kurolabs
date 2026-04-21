import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/thoughts_providers.dart';
import '../repositories/thoughts_repository.dart';
import 'thought_capture_sheet.dart';

class ThoughtListScreen extends ConsumerStatefulWidget {
  const ThoughtListScreen({super.key});

  @override
  ConsumerState<ThoughtListScreen> createState() => _ThoughtListScreenState();
}

class _ThoughtListScreenState extends ConsumerState<ThoughtListScreen> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final thoughtsAsync = ref.watch(thoughtListProvider(_page));

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        title: const Text(
          '想い · Omoi',
          style: TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFA78BFA)),
            onPressed: () => _showCapture(context),
          ),
        ],
      ),
      body: thoughtsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (thoughts) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(thoughtListProvider(_page)),
          child: thoughts.isEmpty
              ? const Center(
                  child: Text(
                    'No thoughts yet.\nTap + to capture your first one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: thoughts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) => _ThoughtTile(
                    thought: thoughts[i],
                    onTap: () => context.push('/omoi/thoughts/${thoughts[i].id}'),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCapture(context),
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Capture'),
      ),
    );
  }

  void _showCapture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ThoughtCaptureSheet(
        onCaptured: () => ref.invalidate(thoughtListProvider(_page)),
      ),
    );
  }
}

class _ThoughtTile extends StatelessWidget {
  final Thought thought;
  final VoidCallback onTap;

  const _ThoughtTile({required this.thought, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: const Color(0xFF2D2D2D)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              thought.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFFE8E8E8), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _CategoryChip(thought.category),
                const Spacer(),
                Text(
                  _timeAgo(thought.createdAt),
                  style: const TextStyle(color: Color(0xFF4B5563), fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _CategoryChip extends StatelessWidget {
  final ThoughtCategory category;

  const _CategoryChip(this.category);

  static const _colors = {
    ThoughtCategory.question: Color(0xFF1D4ED8),
    ThoughtCategory.reminder: Color(0xFFB45309),
    ThoughtCategory.insight: Color(0xFF065F46),
    ThoughtCategory.idea: Color(0xFF6D28D9),
    ThoughtCategory.other: Color(0xFF374151),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (_colors[category] ?? const Color(0xFF374151)).withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category.name,
        style: const TextStyle(color: Color(0xFFE5E7EB), fontSize: 11),
      ),
    );
  }
}
