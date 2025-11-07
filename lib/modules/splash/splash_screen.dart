import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/main_scaffold.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class CustomHeart extends StatefulWidget {
  const CustomHeart({super.key});

  @override
  State<CustomHeart> createState() => _CustomHeartState();
}

class _CustomHeartState extends State<CustomHeart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: CustomPaint(size: const Size(100, 100), painter: HeartPainter()),
    );
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDF314D)
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width / 2, height * 0.25);
    path.cubicTo(
      width * 0.1,
      height * 0.1,
      width * 0.1,
      height * 0.4,
      width / 2,
      height * 0.7,
    );
    path.cubicTo(
      width * 0.9,
      height * 0.4,
      width * 0.9,
      height * 0.1,
      width / 2,
      height * 0.25,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedHeart extends StatefulWidget {
  final Duration delay;

  const AnimatedHeart({super.key, required this.delay});

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(_controller);

    Future.delayed(widget.delay, () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomPaint(size: const Size(20, 20), painter: HeartPainter()),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<Offset> _logoOffset;

  late AnimationController _textAnimationController;
  late List<Animation<double>> _charAnimations;

  final String _shyEyes = "Digital fate, real feels";

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoOffset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
        );

    _logoController.forward();

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _charAnimations = List.generate(_shyEyes.length, (index) {
      final delay = index * 0.05;
      final end = (delay + 0.3).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _textAnimationController,
        curve: Interval(delay, end, curve: Curves.easeIn),
      );
    });

    _textAnimationController.forward();

    /// Navigation check with token
    Future.delayed(const Duration(seconds: 4), () async {
      String? token = await SharedPrefHelper.getToken();

      if (token != null && token.isNotEmpty) {
        Get.offAll(() => MainScaffold()); //  User logged in
      } else {
        Get.offAll(() => LoginView()); // User not logged in
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      body: Stack(
        children: [
          /// Left hearts
          Positioned(
            bottom: 20,
            left: -30,
            child: RepaintBoundary(child: const CustomHeart()),
          ),

          /// Right hearts
          Positioned(
            bottom: 20,
            right: -30,
            child: RepaintBoundary(child: const CustomHeart()),
          ),

          /// Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              /// Logo sliding up
              Center(
                child: SlideTransition(
                  position: _logoOffset,
                  child: Image.asset('assets/images/logo.png', height: 90),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        RepaintBoundary(
                          child: Container(
                            height: 380,
                            width: 380,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  child: Image.asset(
                                    'assets/images/splash_image.jpg',
                                    height: 380,
                                    width: 380,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Multiple small animated hearts over the image
                        Positioned(
                          top: 50,
                          left: 50,
                          child: const AnimatedHeart(
                            delay: Duration(milliseconds: 500),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          right: 70,
                          child: const AnimatedHeart(
                            delay: Duration(milliseconds: 1000),
                          ),
                        ),
                        Positioned(
                          bottom: 80,
                          left: 80,
                          child: const AnimatedHeart(
                            delay: Duration(milliseconds: 1500),
                          ),
                        ),
                        Positioned(
                          bottom: 120,
                          right: 50,
                          child: const AnimatedHeart(
                            delay: Duration(milliseconds: 2000),
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 120,
                          child: const AnimatedHeart(
                            delay: Duration(milliseconds: 2500),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          right: 120,
                          child: const AnimatedHeart(
                            delay: Duration(milliseconds: 3000),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Animated tagline text below the image
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(_shyEyes.length, (index) {
                        final char = _shyEyes[index];

                        return FadeTransition(
                          opacity: _charAnimations[index],
                          child: Text(
                            char,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDF314D),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
