import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surfaceContainerLow,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(.1)
                  : Colors.transparent,
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GNav(
              selectedIndex: navigationShell.currentIndex,
              onTabChange: _onTap,
              rippleColor: Theme.of(context).colorScheme.surfaceContainer,
              hoverColor: Theme.of(context).colorScheme.surfaceContainer,
              gap: 8,
              activeColor: Theme.of(context).colorScheme.onPrimary,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Colors.transparent,
              tabs: [
                GButton(
                  icon: Icons.restaurant,
                  text: 'Meals',
                ),
                GButton(
                  icon: Icons.shopping_cart,
                  text: 'Grocery',
                ),
                GButton(
                  icon: Icons.lightbulb,
                  text: 'Ideas',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
