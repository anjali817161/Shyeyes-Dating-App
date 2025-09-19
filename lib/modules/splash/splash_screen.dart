import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shyeyes/modules/auth/login/view/login_view.dart';
import 'package:shyeyes/modules/main_scaffold.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

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
        Get.offAll(() => LoginView()); //  User logged in
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
            child: RepaintBoundary(
              child: Lottie.asset(
                'assets/splash/heart.json',
                height: 400,
                width: 150,
                fit: BoxFit.fitHeight,
                repeat: true,
              ),
            ),
          ),

          /// Right hearts
          Positioned(
            bottom: 20,
            right: -30,
            child: RepaintBoundary(
              child: Lottie.asset(
                'assets/splash/heart.json',
                height: 400,
                width: 150,
                fit: BoxFit.fitHeight,
                repeat: true,
              ),
            ),
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

              /// Splash animation and animated text
              Center(
                child: Column(
                  children: [
                    RepaintBoundary(
                      child: Lottie.asset(
                        'assets/splash/splash_screen.json',
                        height: 280,
                        width: 280,
                        fit: BoxFit.contain,
                        repeat: false, // ✅ Play once
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Animated tagline text
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
