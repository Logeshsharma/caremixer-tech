import 'package:caremixer/ui/chat/widgets/chat_screen.dart';
import 'package:caremixer/ui/home/home_screen.dart';
import 'package:caremixer/ui/pokemon_list/widgets/pokemon_list_screen.dart';
import 'package:caremixer/ui/timeline_list/widgets/timeline_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.timeline,
    routes: [
      ShellRoute(
          builder: (context, state, child) => HomeScreen(child: child),
          routes: [
            GoRoute(
              path: Routes.timeline,
              name: 'Timeline',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: TimelineListScreen(),
              ),
            ),
            GoRoute(
              path: Routes.pokemonList,
              name: 'Pokemon List',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PokemonListScreen(),
              ),
            ),
          ]),
      GoRoute(
        path: Routes.chat,
        name: 'Chat',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ChatScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(Routes.timeline),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
