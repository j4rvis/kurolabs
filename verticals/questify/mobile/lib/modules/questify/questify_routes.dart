import 'package:go_router/go_router.dart';
import 'shared/widgets/app_shell.dart';
import 'questify_screen.dart';
import 'features/quests/screens/create_quest_screen.dart';
import 'features/quests/screens/quest_detail_screen.dart';
import 'features/character/screens/character_sheet_screen.dart';
import 'features/epics/screens/epics_screen.dart';
import 'features/village/screens/village_screen.dart';
import 'features/village/screens/npc_detail_screen.dart';
import 'features/quest_givers/screens/quest_givers_screen.dart';
import 'features/quest_givers/screens/invite_screen.dart';
import 'features/quest_givers/screens/giver_detail_screen.dart';

final questifyRoutes = [
  ShellRoute(
    builder: (context, state, child) => AppShell(child: child),
    routes: [
      GoRoute(
        path: '/questify',
        builder: (context, state) => const QuestifyScreen(),
        routes: [
          GoRoute(
            path: 'quests/create',
            builder: (context, state) => CreateQuestScreen(
              questGiverId: state.uri.queryParameters['questGiverId'],
            ),
          ),
          GoRoute(
            path: 'quests/:id',
            builder: (context, state) => QuestDetailScreen(
              questId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/character',
        builder: (context, state) => const CharacterSheetScreen(),
      ),
      GoRoute(
        path: '/epics',
        builder: (context, state) => const EpicsScreen(),
      ),
      GoRoute(
        path: '/village',
        builder: (context, state) => const VillageScreen(),
        routes: [
          GoRoute(
            path: ':npcId',
            builder: (context, state) => NpcDetailScreen(
              npcId: state.pathParameters['npcId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/quest-givers',
        builder: (context, state) => const QuestGiversScreen(),
        routes: [
          GoRoute(
            path: 'invite',
            builder: (context, state) => const InviteScreen(),
          ),
          GoRoute(
            path: ':id/detail',
            builder: (context, state) => GiverDetailScreen(
              relationshipId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
  ),
];
