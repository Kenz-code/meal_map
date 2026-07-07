import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/app/app.dart';
import 'package:meal_map/app/app_provider.dart';
import 'package:meal_map/core/widgets/scaffold_with_nav_bar.dart';
import 'package:meal_map/features/auth/screens/login_page.dart';
import 'package:meal_map/features/auth/screens/signup_page.dart';
import 'package:meal_map/features/grocery/screens/add_grocery_page.dart';
import 'package:meal_map/features/grocery/screens/grocery_page.dart';
import 'package:meal_map/features/home/models/meal_data.dart';
import 'package:meal_map/features/home/screens/create_meal_page.dart';
import 'package:meal_map/features/home/screens/edit_meal_page.dart';
import 'package:meal_map/features/home/screens/meals_page.dart';
import 'package:meal_map/features/ideas/screens/add_ideas_page.dart';
import 'package:meal_map/features/ideas/screens/ideas_page.dart';
import 'package:meal_map/features/onboarding/screens/household_setup_page.dart';
import 'package:meal_map/features/onboarding/screens/onboarding_page.dart';
import 'package:meal_map/features/settings/screens/settings_page.dart';
import 'package:provider/provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AppStateNotifier appStateNotifier) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    refreshListenable: appStateNotifier,
    redirect: (context, state) {
      final appState = Provider.of<AppStateNotifier>(context, listen: false);

      if (!appState.initialized) return null;

      final isLoggedIn = appState.isLoggedIn;
      final isFirstLaunch = appState.isFirstLaunch;
      final fullPath = state.fullPath ?? '';

      final goingToAuth = fullPath.startsWith('/auth');
      final goingToOnboarding = fullPath == '/onboarding';
      final goingToHouseholdSetup = fullPath == '/householdSetup';
      final goingToShell = fullPath.startsWith('/meals') ||
          fullPath.startsWith('/grocery') ||
          fullPath.startsWith('/ideas') ||
          fullPath.startsWith('/settings');

      if (kDebugMode) {
        print(
          "Redirect check: isLoggedIn=$isLoggedIn, isFirstLaunch=$isFirstLaunch, fullPath=$fullPath");
      }

      // Redirect to onboarding if needed
      if (isFirstLaunch && !goingToOnboarding) {
        return '/onboarding';
      }

      // If onboarding is complete but user is still on onboarding screen, redirect them away
      if (!isFirstLaunch && goingToOnboarding) {
        return isLoggedIn ? '/meals' : '/onboarding';
      }

      // If not logged in and not in auth flow, redirect to login
      if (!isLoggedIn && !goingToAuth && !goingToHouseholdSetup) {
        return '/auth/login';
      }

      // If logged in and on root, redirect to meals
      if (isLoggedIn && fullPath == '/') {
        return '/meals';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/householdSetup',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const HouseholdSetupPage(),
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 1000),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {

              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubicEmphasized,
                  ),
                ),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => SignupPage(),
      ),
      StatefulShellRoute.indexedStack(
        // builder: (context, state, shell) => ScaffoldWithNavBar(navigationShell: shell),
        builder: (context, state, shell) =>
            ScaffoldWithNavBar(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/meals',
              builder: (context, state) => HomePage(),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    // return MealDetailPage(id: id);
                    return MyHomePage(title: "awesome");
                  },
                ),
                GoRoute(
                  path: 'create',
                  parentNavigatorKey: _rootNavigatorKey, // <— THIS IS IMPORTANT
                  pageBuilder: (context, state) {
                    final fald = state.extra as List<DateTime>;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: CreateMealPage(
                        firstAndLastDays: fald,
                      ),
                      reverseTransitionDuration:
                          const Duration(milliseconds: 150), // faster animation
                      transitionDuration:
                          const Duration(milliseconds: 150), // faster animation
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final fade = CurvedAnimation(
                            parent: animation, curve: Curves.easeInOut);
                        final scale =
                            Tween<double>(begin: 0.95, end: 1.0).animate(fade);
                        final slide = Tween<Offset>(
                          begin: const Offset(0, 0.1), // 10% down
                          end: Offset.zero,
                        ).animate(fade);

                        return FadeTransition(
                          opacity: fade,
                          child: SlideTransition(
                            position: slide,
                            child: ScaleTransition(
                              scale: scale,
                              child: child,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                GoRoute(
                  path: 'edit',
                  parentNavigatorKey: _rootNavigatorKey, // <— THIS IS IMPORTANT
                  pageBuilder: (context, state) {
                    final mealData = state.extra as MealData;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: EditMealPage(
                        oldMealData: mealData,
                      ),
                      reverseTransitionDuration:
                      const Duration(milliseconds: 150), // faster animation
                      transitionDuration:
                      const Duration(milliseconds: 150), // faster animation
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final fade = CurvedAnimation(
                            parent: animation, curve: Curves.easeInOut);
                        final scale =
                        Tween<double>(begin: 0.95, end: 1.0).animate(fade);
                        final slide = Tween<Offset>(
                          begin: const Offset(0, 0.1), // 10% down
                          end: Offset.zero,
                        ).animate(fade);

                        return FadeTransition(
                          opacity: fade,
                          child: SlideTransition(
                            position: slide,
                            child: ScaleTransition(
                              scale: scale,
                              child: child,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/grocery',
              builder: (context, state) => GroceryPage(),
              routes: [
                GoRoute(
                  path: 'create',
                  parentNavigatorKey: _rootNavigatorKey, // <— THIS IS IMPORTANT
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const AddGroceryPage(),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 150), // faster animation
                    transitionDuration:
                        const Duration(milliseconds: 150), // faster animation
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final fade = CurvedAnimation(
                          parent: animation, curve: Curves.easeInOut);
                      final scale =
                          Tween<double>(begin: 0.95, end: 1.0).animate(fade);
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.1), // 10% down
                        end: Offset.zero,
                      ).animate(fade);

                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(
                          position: slide,
                          child: ScaleTransition(
                            scale: scale,
                            child: child,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/ideas',
              builder: (context, state) => IdeasPage(),
              routes: [
                GoRoute(
                  path: 'create',
                  parentNavigatorKey: _rootNavigatorKey, // <— THIS IS IMPORTANT
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const AddIdeasPage(),
                    reverseTransitionDuration:
                    const Duration(milliseconds: 150), // faster animation
                    transitionDuration:
                    const Duration(milliseconds: 150), // faster animation
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final fade = CurvedAnimation(
                          parent: animation, curve: Curves.easeInOut);
                      final scale =
                      Tween<double>(begin: 0.95, end: 1.0).animate(fade);
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.1), // 10% down
                        end: Offset.zero,
                      ).animate(fade);

                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(
                          position: slide,
                          child: ScaleTransition(
                            scale: scale,
                            child: child,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => SettingsPage(),
            )
          ]),
        ],
      )
    ],
  );
}
