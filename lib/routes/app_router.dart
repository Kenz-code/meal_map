import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/app/app.dart';
import 'package:meal_map/app/app_provider.dart';
import 'package:provider/provider.dart';

GoRouter createRouter(AppStateNotifier appStateNotifier) {
  return GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: appStateNotifier,
    redirect: (context, state) {
      final appState = Provider.of<AppStateNotifier>(context, listen: false);

      if (!appState.initialized) return null; // Show splash or wait

      final isLoggedIn = appState.isLoggedIn;
      final isFirstLaunch = appState.isFirstLaunch;

      final goingToAuth = state.fullPath!.startsWith('/auth');
      final goingToOnboarding = state.fullPath == '/onboarding';

      if (isFirstLaunch && !goingToOnboarding) return '/onboarding';
      if (!isLoggedIn && !goingToAuth) return '/auth/login';
      if (isLoggedIn && goingToAuth) return '/meals';

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => MyHomePage(title: "awesome"),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => MyHomePage(title: "awesome"),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => MyHomePage(title: "awesome"),
      ),
      StatefulShellRoute.indexedStack(
        // builder: (context, state, shell) => ScaffoldWithNavBar(navigationShell: shell),
        builder: (context, state, shell) => Scaffold(),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/meals',
              builder: (context, state) => MyHomePage(title: "awesome"),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    // return MealDetailPage(id: id);
                    return MyHomePage(title: "awesome");
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/grocery',
              builder: (context, state) => MyHomePage(title: "awesome"),
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/ideas',
              builder: (context, state) => MyHomePage(title: "awesome"),
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => MyHomePage(title: "awesome"),
            )
          ]),
        ],
      )
    ],
  );
}
