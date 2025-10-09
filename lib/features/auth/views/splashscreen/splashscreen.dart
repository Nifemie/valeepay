import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const SplashScreen({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _backgroundController;
  late AnimationController _textController;

  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _borderRadiusAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation controller (logo grows from small to large)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Background color animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Text fade animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Scale animation (60 to 120)
    _scaleAnimation = Tween<double>(
      begin: 60.0,
      end: 120.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Border radius animation (square to circle)
    _borderRadiusAnimation = Tween<double>(
      begin: 12.0,
      end: 60.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Background color animation (black to orange)
    _backgroundAnimation = ColorTween(
      begin: const Color(0xFF000000),
      end: const Color(0xFFF76301),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Text opacity animation
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Start the animation sequence
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // Wait a bit before starting
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 1: Scale up the logo
    await _scaleController.forward();

    // Step 2: Change background to orange
    await _backgroundController.forward();

    // Step 3: Fade in the text
    await _textController.forward();

    // Wait a bit before completing
    await Future.delayed(const Duration(milliseconds: 800));

    // Navigate to next screen
    widget.onAnimationComplete();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _backgroundController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _scaleController,
          _backgroundController,
          _textController,
        ]),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: _backgroundAnimation.value,
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: _scaleAnimation.value,
                    height: _scaleAnimation.value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        _borderRadiusAnimation.value,
                      ),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          _borderRadiusAnimation.value,
                        ),
                        child: Image.asset(
                          'assets/images/launcher.png',
                          width: _scaleAnimation.value * 0.8,
                          height: _scaleAnimation.value * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // Text (fades in)
                  Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: const Text(
                        'Valarpay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

