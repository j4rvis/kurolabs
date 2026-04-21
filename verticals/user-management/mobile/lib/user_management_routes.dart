import 'package:go_router/go_router.dart';
import 'user_management_screen.dart';

final userManagementRoutes = [
  GoRoute(
    path: '/hub/user-management',
    builder: (context, state) => const UserManagementScreen(),
  ),
];
