import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const Scaffold(
        body: Center(child: Text('__VERTICAL_PASCAL__')),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const Scaffold(
        body: Center(child: Text('Login')),
      ),
    ),
  ],
);

final routerProvider = Provider((_) => _router);

class __VERTICAL_PASCAL__App extends ConsumerWidget {
  const __VERTICAL_PASCAL__App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '__VERTICAL_PASCAL__',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
