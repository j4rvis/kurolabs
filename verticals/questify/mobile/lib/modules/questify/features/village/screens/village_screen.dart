import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../providers/village_provider.dart';
import '../widgets/npc_card.dart';

class VillageScreen extends ConsumerWidget {
  const VillageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final npcsAsync = ref.watch(villageNpcsProvider);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.inkBrown,
        foregroundColor: AppColors.parchment,
        title: Text(
          'The Village',
          style: AppTextStyles.questTitle.copyWith(color: AppColors.parchment),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline, color: AppColors.goldAccent),
            tooltip: 'My Companions',
            onPressed: () => context.push('/quest-givers'),
          ),
        ],
      ),
      body: npcsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (npcs) {
          final connected = npcs.where((n) => n['is_connected'] == true).toList();
          final unconnected = npcs.where((n) => n['is_connected'] != true).toList();

          return CustomScrollView(
            slivers: [
              if (connected.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'YOUR QUEST GIVERS',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.goldAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => NpcCard(
                        npc: connected[i],
                        onTap: () => context.push('/village/${connected[i]['id']}'),
                      ),
                      childCount: connected.length,
                    ),
                  ),
                ),
              ],
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    connected.isEmpty ? 'ALL QUEST GIVERS' : 'DISCOVER MORE',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.inkBrownLight,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => NpcCard(
                      npc: unconnected[i],
                      onTap: () => context.push('/village/${unconnected[i]['id']}'),
                    ),
                    childCount: unconnected.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
