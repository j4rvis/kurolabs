import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../providers/quest_provider.dart';
import '../widgets/quest_card.dart';
import '../widgets/quest_type_tab_bar.dart';

class QuestBoardScreen extends ConsumerStatefulWidget {
  const QuestBoardScreen({super.key});

  @override
  ConsumerState<QuestBoardScreen> createState() => _QuestBoardScreenState();
}

class _QuestBoardScreenState extends ConsumerState<QuestBoardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _types = ['daily', 'side', 'epic'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _types.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentType = _types[_tabController.index];
    final questsAsync = ref.watch(questsByTypeProvider(currentType));

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.inkBrown,
        foregroundColor: AppColors.parchment,
        title: Text('Quest Board', style: AppTextStyles.questTitle.copyWith(color: AppColors.parchment)),
        elevation: 0,
        bottom: QuestTypeTabBar(controller: _tabController),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.goldAccent),
            onPressed: () => context.push('/home/quests/create'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(questsByTypeProvider(currentType)),
        child: questsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text('Error: $e', style: AppTextStyles.bodyMedium)),
              ),
            ],
          ),
          data: (quests) => quests.isEmpty
              ? ListView(
                  children: [_EmptyState(questType: currentType)],
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: quests.length,
                  itemBuilder: (context, index) {
                    final quest = quests[index];
                    return QuestCard(
                      quest: quest,
                      onTap: () => context.push('/home/quests/${quest['id']}'),
                      onComplete: () => ref.read(questsByTypeProvider(currentType).notifier)
                          .completeQuest(quest['id'] as String),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.questType});
  final String questType;

  @override
  Widget build(BuildContext context) {
    final labels = {'daily': 'Daily Quests', 'side': 'Side Quests', 'epic': 'Epic Quests'};
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_stories, size: 64, color: AppColors.parchmentBorder),
          const SizedBox(height: 16),
          Text('No ${labels[questType] ?? 'Quests'} Yet', style: AppTextStyles.questTitle),
          const SizedBox(height: 8),
          Text('Tap + to add your first quest', style: AppTextStyles.italic),
        ],
      ),
    );
  }
}
