import 'package:flutter/material.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';

class ProgressToCheck extends StatefulWidget {
  final bool completed;

  const ProgressToCheck({
    super.key,
    required this.completed,
  });

  @override
  State<ProgressToCheck> createState() => _ProgressToCheckState();
}

class _ProgressToCheckState extends State<ProgressToCheck>
    with SingleTickerProviderStateMixin {

  bool showCheck = false;

  @override
  void initState() {
    super.initState();

    if (widget.completed) {
      _complete();
    }
  }

  @override
  void didUpdateWidget(covariant ProgressToCheck oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.completed && !oldWidget.completed) {
      _complete();
    }
  }

  Future<void> _complete() async {
    setState(() {
      showCheck = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchOutCurve: Curves.easeInOutCubic,
      switchInCurve: Curves.easeInOutCubic,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: RotationTransition(
            turns: Tween<double>(
              begin: 0,
              end: 5,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            ),),
            child: child,
          ),
        );
      },
      child: showCheck
          ? Icon(
        Icons.check_circle_rounded,
        key: const ValueKey("check"),
        color: context.colorScheme.primary,
        size: 100,
      )
          : SizedBox(
        key: const ValueKey("loading"),
        width: 30,
        height: 30,
        child: CircularProgressIndicator()
      ),
    );
  }
}