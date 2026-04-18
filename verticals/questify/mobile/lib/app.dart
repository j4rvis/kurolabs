import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'router/app_router.dart';

class QuestifyApp extends ConsumerWidget {
  const QuestifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return UpgradeAlert(
      child: MaterialApp.router(
      title: 'Questify',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.parchment,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.inkBrown,
          surface: AppColors.parchment,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.inkBrown,
          foregroundColor: AppColors.parchment,
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          titleLarge: AppTextStyles.questTitle,
          labelLarge: AppTextStyles.label,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.parchmentDark,
          labelStyle: AppTextStyles.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.parchmentBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.parchmentBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.inkBrown, width: 1.5),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.parchmentDark,
          side: const BorderSide(color: AppColors.parchmentBorder),
          labelStyle: AppTextStyles.caption,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.goldAccent,
        ),
      ),
      ),
    );
  }
}
