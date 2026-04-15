import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../hub/hub_screen.dart';
import '../modules/questify/features/auth/providers/auth_provider.dart';
import '../modules/questify/features/auth/screens/login_screen.dart';
import '../modules/questify/features/auth/screens/signup_screen.dart';
import '../modules/questify/questify_routes.dart';

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
        builder: (context, state) => const HubScreen(),
      ),
      ...questifyRoutes,
    ],
  );
});
