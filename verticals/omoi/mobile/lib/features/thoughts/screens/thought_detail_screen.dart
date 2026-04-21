import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/thoughts_providers.dart';
import '../repositories/thoughts_repository.dart';

class ThoughtDetailScreen extends ConsumerWidget {
  final String thoughtId;

  const ThoughtDetailScreen({super.key, required this.thoughtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thoughtAsync = ref.watch(thoughtDetailProvider(thoughtId));
    final connectionsAsync = ref.watch(thoughtConnectionsProvider(thoughtId));

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        foregroundColor: const Color(0xFFA78BFA),
        title: const Text('Thought', style: TextStyle(color: Color(0xFFE8E8E8))),
        actions: [
          thoughtAsync.whenOrNull(
            data: (thought) => IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
              onPressed: () => _confirmDelete(context, ref, thought),
            ),
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: thoughtAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (thought) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ThoughtCard(thought: thought, onEdit: (content) async {
              final repo = ref.read(thoughtsRepositoryProvider);
              await repo.updateThought(thought.id, content: content);
              ref.invalidate(thoughtDetailProvider(thoughtId));
            }),
            const SizedBox(height: 24),
            connectionsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (connections) => connections.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Connected thoughts',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...connections.map((c) => GestureDetector(
                          onTap: () => context.push('/omoi/thoughts/${c.id}'),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              border: Border.all(color: const Color(0xFF2D2D2D)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              c.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 13),
                            ),
                          ),
                        )),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Thought thought) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Delete thought?', style: TextStyle(color: Color(0xFFE8E8E8))),
        content: const Text('This cannot be undone.', style: TextStyle(color: Color(0xFF9CA3AF))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final repo = ref.read(thoughtsRepositoryProvider);
      await repo.deleteThought(thought.id);
      if (context.mounted) context.pop();
    }
  }
}

class _ThoughtCard extends StatefulWidget {
  final Thought thought;
  final Future<void> Function(String content) onEdit;

  const _ThoughtCard({required this.thought, required this.onEdit});

  @override
  State<_ThoughtCard> createState() => _ThoughtCardState();
}

class _ThoughtCardState extends State<_ThoughtCard> {
  bool _editing = false;
  late final _controller = TextEditingController(text: widget.thought.content);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF2D2D2D)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_editing)
            TextField(
              controller: _controller,
              maxLines: null,
              autofocus: true,
              style: const TextStyle(color: Color(0xFFE8E8E8), fontSize: 14, height: 1.6),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF111111),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF7C3AED)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF7C3AED)),
                ),
              ),
            )
          else
            Text(
              widget.thought.content,
              style: const TextStyle(color: Color(0xFFE8E8E8), fontSize: 14, height: 1.6),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.thought.tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('#$t', style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontFamily: 'monospace')),
            )).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (_editing) ...[
                TextButton(
                  onPressed: () async {
                    await widget.onEdit(_controller.text.trim());
                    setState(() => _editing = false);
                  },
                  child: const Text('Save', style: TextStyle(color: Color(0xFFA78BFA))),
                ),
                TextButton(
                  onPressed: () {
                    _controller.text = widget.thought.content;
                    setState(() => _editing = false);
                  },
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
                ),
              ] else
                TextButton(
                  onPressed: () => setState(() => _editing = true),
                  child: const Text('Edit', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
