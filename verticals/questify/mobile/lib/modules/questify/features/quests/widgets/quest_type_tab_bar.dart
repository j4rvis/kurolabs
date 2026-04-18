import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class QuestTypeTabBar extends StatelessWidget implements PreferredSizeWidget {
  const QuestTypeTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  Size get preferredSize => const Size.fromHeight(42);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.inkBrown,
      child: TabBar(
        controller: controller,
        labelColor: AppColors.goldAccent,
        unselectedLabelColor: AppColors.parchmentBorder,
        labelStyle: AppTextStyles.sectionHeader.copyWith(fontSize: 12),
        unselectedLabelStyle: AppTextStyles.caption.copyWith(fontSize: 12),
        indicatorColor: AppColors.goldAccent,
        indicatorWeight: 2,
        tabs: const [
          Tab(text: 'DAILY'),
          Tab(text: 'SIDE QUESTS'),
          Tab(text: 'EPIC'),
        ],
      ),
    );
  }
}
