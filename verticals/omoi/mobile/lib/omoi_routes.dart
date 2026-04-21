import 'package:go_router/go_router.dart';
import 'features/thoughts/screens/thought_list_screen.dart';
import 'features/thoughts/screens/thought_detail_screen.dart';

final omoiRoutes = [
  GoRoute(
    path: '/omoi',
    builder: (context, state) => const ThoughtListScreen(),
    routes: [
      GoRoute(
        path: 'thoughts/:id',
        builder: (context, state) => ThoughtDetailScreen(
          thoughtId: state.pathParameters['id']!,
        ),
      ),
    ],
  ),
];
