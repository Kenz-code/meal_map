import 'package:flutter/material.dart';

class FallingPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FallingPageRoute({
    required this.page,
  }) : super(
    transitionDuration: const Duration(milliseconds: 1000),
    pageBuilder: (_, animation, __) => page,
    transitionsBuilder: (_, animation, __, child) {

      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubicEmphasized,
      );

      return Stack(
        children: [

          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),

        ],
      );
    },
  );
}