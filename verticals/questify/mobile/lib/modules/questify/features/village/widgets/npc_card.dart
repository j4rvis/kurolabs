import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class NpcCard extends StatelessWidget {
  const NpcCard({super.key, required this.npc, required this.onTap});

  final Map<String, dynamic> npc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final questCount = (npc['accepted_quest_count'] as int? ?? 0);
    final isConnected = npc['is_connected'] as bool? ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.parchment,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isConnected
                ? AppColors.goldAccent.withAlpha(180)
                : AppColors.parchmentBorder.withAlpha(120),
            width: isConnected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.inkBrown.withAlpha(15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Portrait
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/npc/${npc['image_filename']}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.parchmentBorder.withAlpha(60),
                        child: const Icon(Icons.person, size: 48, color: AppColors.parchmentBorder),
                      ),
                    ),
                    // NPC badge top-left
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B1F6A),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'NPC',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    // Quest count badge top-right
                    if (questCount > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.goldAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department, size: 10, color: AppColors.inkBrown),
                              const SizedBox(width: 2),
                              Text(
                                '$questCount',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.inkBrown,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info footer
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    npc['name'] as String,
                    style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    npc['category'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.inkBrownLight,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
