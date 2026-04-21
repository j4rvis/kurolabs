import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurolabs_auth/kurolabs_auth.dart';
import 'package:kurolabs_hub/kurolabs_hub.dart';
import 'package:omoi_module/omoi_module.dart';
import 'package:questify_module/questify_module.dart';
import 'package:user_management_module/user_management_module.dart';
import '../core/constants/app_colors.dart';
import '../features/shell/auth/login_screen.dart';
import '../features/shell/auth/signup_screen.dart';
import '../features/shell/modules.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/hub',
    redirect: (context, state) {
      final isAuthenticated =
          authState.whenOrNull(data: (s) => s.session != null) ?? false;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      if (!isAuthenticated && !isAuthRoute) return '/auth/login';
      if (isAuthenticated && isAuthRoute) return '/hub';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/hub',
        builder: (context, state) => HubScreen(
          modules: registeredModules,
        ),
      ),
      ...omoiRoutes,
      ...questifyRoutes,
      ...userManagementRoutes,
    ],
  );
});
