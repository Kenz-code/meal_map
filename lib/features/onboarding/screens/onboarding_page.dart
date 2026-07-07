import 'package:auto_size_text/auto_size_text.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/features/onboarding/screens/household_setup_page.dart';
import 'package:meal_map/features/onboarding/widgets/falling_page_route.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  static const _logoAsset = "assets/logo/mealmaplogo_Transparent_png.png";

  late final AnimationController _controller;
  late final AnimationController _exitController;
  late final AnimationController _buttonController;

  late final Animation<double> _buttonBounce;
  late final Animation<Offset> _pageExit;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  late final Animation<double> _tab1Opacity;
  late final Animation<Offset> _tab1Offset;

  late final Animation<double> _tab2Opacity;
  late final Animation<Offset> _tab2Offset;

  late final Animation<double> _tab3Opacity;
  late final Animation<Offset> _tab3Offset;

  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.35, curve: Curves.easeOut),
    );

    _logoScale = Tween(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.35, curve: Curves.easeOutBack),
      ),
    );

    _tab1Opacity = _fade(0.45, 0.60);
    _tab1Offset = _slide(0.45, 0.60, const Offset(-0.08, 0));

    _tab2Opacity = _fade(0.55, 0.70);
    _tab2Offset = _slide(0.55, 0.70, const Offset(0.08, 0));

    _tab3Opacity = _fade(0.65, 0.80);
    _tab3Offset = _slide(0.65, 0.80, const Offset(-0.08, 0));

    _buttonOpacity = _fade(0.82, 1.00);
    _buttonOffset = _slide(0.82, 1.00, const Offset(0, 0.15));




    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _buttonBounce = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -30.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -30.0, end: 100.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_buttonController);


    _pageExit = Tween(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  Animation<double> _fade(double begin, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: Curves.easeOut),
    );
  }

  Animation<Offset> _slide(
      double begin,
      double end,
      Offset start,
      ) {
    return Tween(
      begin: start,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Future<void> _continue() async {
    _buttonController.forward();

    if (!mounted) return;

    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    _exitController.forward();

    Navigator.push(
      context,
      FallingPageRoute(
        page: const HouseholdSetupPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _exitController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return SlideTransition(
      position: _pageExit,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: Image.asset(
                      _logoAsset,
                      isAntiAlias: false,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),

                SizedBox(
                  height: (height >= 840) ? 60 : 30,
                ),

                SlideFade(
                  opacity: _tab1Opacity,
                  offset: _tab1Offset,
                  child: const NumberedTab(
                    title: "Plan meals",
                    index: 1,
                  ),
                ),

                SizedBox(
                  height: (height >= 840) ? 32 : 12,
                ),

                SlideFade(
                  opacity: _tab2Opacity,
                  offset: _tab2Offset,
                  child: const NumberedTab(
                    title: "Share groceries",
                    index: 2,
                    inverse: true,
                  ),
                ),

                SizedBox(
                  height: (height >= 840) ? 32 : 12,
                ),

                SlideFade(
                  opacity: _tab3Opacity,
                  offset: _tab3Offset,
                  child: const NumberedTab(
                    title: "Keep your household organized",
                    index: 3,
                  ),
                ),

                Spacer(),

                FadeTransition(
                  opacity: _buttonOpacity,
                  child: SlideTransition(
                    position: _buttonOffset,
                    child: AnimatedBuilder(
                      animation: _buttonBounce,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: _continue,
                            child: "Get started".text(),
                          ).expanded1,
                        ],
                      ),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _buttonBounce.value),
                          child: child
                        );
                      }
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


class NumberedTab extends StatelessWidget {
  final String title;
  final int index;
  final bool inverse;

  const NumberedTab({
    super.key,
    required this.title,
    required this.index,
    this.inverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final number = index.toString().text(
      style: context.textTheme.displayLarge!.copyWith(
        color: context.colorScheme.primary,
      ),
    );

    final label = AutoSizeText(
      title,
      style: context.textTheme.labelLarge!.copyWith(
        letterSpacing: 0.75,
      ),
    );

    return Row(
      mainAxisAlignment:
      inverse ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: inverse
          ? [label, 16.gapRow, number]
          : [number, 16.gapRow, label],
    );
  }
}

class SlideFade extends StatelessWidget {
  final Animation<double> opacity;
  final Animation<Offset> offset;
  final Widget child;

  const SlideFade({
    super.key,
    required this.opacity,
    required this.offset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: offset,
        child: child,
      ),
    );
  }
}
