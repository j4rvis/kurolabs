import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurolabs_auth/kurolabs_auth.dart';
import 'package:kurolabs_hub/kurolabs_hub.dart';
import '../modules/questify/features/auth/screens/login_screen.dart';
import '../modules/questify/features/auth/screens/signup_screen.dart';
import '../modules/questify/questify_routes.dart';

const _questifyModule = ModuleConfig(
  name: 'Questify',
  path: '/questify',
  color: Color(0xFF7F77DD),
  icon: Icons.quiz_outlined,
);

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
        builder: (context, state) => const HubScreen(
          modules: [_questifyModule],
        ),
      ),
      ...questifyRoutes,
    ],
  );
});
