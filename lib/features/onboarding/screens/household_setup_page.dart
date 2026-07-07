import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';

class HouseholdSetupPage extends StatefulWidget {
  const HouseholdSetupPage({super.key});

  @override
  State<HouseholdSetupPage> createState() => _HouseholdSetupPageState();
}

class _HouseholdSetupPageState extends State<HouseholdSetupPage>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleScale;
  late final Animation<Offset> _titleOffset;

  late final Animation<double> _questionOpacity;
  late final Animation<double> _questionScale;
  late final Animation<Offset> _questionOffset;

  late final Animation<double> _createOpacity;
  late final Animation<double> _createScale;
  late final Animation<Offset> _createOffset;

  late final Animation<double> _dividerScale;

  late final Animation<double> _joinOpacity;
  late final Animation<double> _joinScale;
  late final Animation<Offset> _joinOffset;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _titleOpacity = _fade(0.0, 0.25);
    _titleScale = _scale(0.0, 0.25);
    _titleOffset = _slide(0.0, 0.25);

    _questionOpacity = _fade(0.15, 0.40);
    _questionScale = _scale(0.15, 0.40);
    _questionOffset = _slide(0.15, 0.40);

    _createOpacity = _fade(0.35, 0.60);
    _createScale = _scale(0.35, 0.60);
    _createOffset = _slide(0.35, 0.60);

    _dividerScale = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.55,
          0.75,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _joinOpacity = _fade(0.70, 0.95);
    _joinScale = _scale(0.70, 0.95);
    _joinOffset = _slide(0.70, 0.95);


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      _controller.forward();
    });
  }


  Animation<double> _fade(double begin, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(
        begin,
        end,
        curve: Curves.easeOut,
      ),
    );
  }


  Animation<double> _scale(double begin, double end) {
    return Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          begin,
          end,
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }


  Animation<Offset> _slide(double begin, double end) {
    return Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          begin,
          end,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget animatedItem({
    required Animation<double> opacity,
    required Animation<double> scale,
    required Animation<Offset> offset,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: offset,
        child: ScaleTransition(
          scale: scale,
          child: child,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              animatedItem(
                opacity: _titleOpacity,
                scale: _titleScale,
                offset: _titleOffset,
                child: "Welcome".text(
                  style: context.textTheme.headlineLarge,
                ),
              ),

              SizedBox(
                height: height >= 840 ? 60 : 45,
              ),


              animatedItem(
                opacity: _questionOpacity,
                scale: _questionScale,
                offset: _questionOffset,
                child: "Do you already have a household?".text(
                  style: context.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),


              SizedBox(
                height: height >= 840 ? 120 : 90,
              ),


              animatedItem(
                opacity: _createOpacity,
                scale: _createScale,
                offset: _createOffset,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.push('/auth/signup');
                      },
                      child: "Create a household".text(),
                    ).expanded1,
                  ],
                ),
              ),


              AnimatedBuilder(
                animation: _dividerScale,
                builder: (context, child) {
                  return Transform.scale(
                    scaleX: _dividerScale.value,
                    child: child,
                  );
                },
                child: const Divider(),
              ),


              animatedItem(
                opacity: _joinOpacity,
                scale: _joinScale,
                offset: _joinOffset,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.push('/auth/login');
                      },
                      child: "Join a household".text(),
                    ).expanded1,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}