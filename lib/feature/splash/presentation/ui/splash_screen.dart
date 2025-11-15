// ignore_for_file: use_build_context_synchronously
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _loadingAnimationController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _loadingProgressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _redirect();
  }

  void _setupAnimations() {
    // Main animation controller
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Pulse animation for logo glow effect
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Loading progress animation
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Logo animations
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Text animations
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    // Pulse animation
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Loading progress
    _loadingProgressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _mainAnimationController.forward();
    _loadingAnimationController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _pulseAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  Future<void> _redirect() async {
    // Wait for animations and loading to complete
    await Future.delayed(const Duration(milliseconds: 2800));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go('/login');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue,
              AppColors.primaryDark,
              AppColors.primaryBlue.withValues(alpha: 0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles in background
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: isSmallScreen ? 20.0 : 32.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo with glow effect
                            AnimatedBuilder(
                              animation: Listenable.merge([
                                _mainAnimationController,
                                _pulseAnimationController,
                              ]),
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: _logoFadeAnimation,
                                  child: ScaleTransition(
                                    scale: _logoScaleAnimation,
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.white.withValues(
                                              alpha:
                                                  0.2 * _pulseAnimation.value,
                                            ),
                                            blurRadius:
                                                40 * _pulseAnimation.value,
                                            spreadRadius:
                                                10 * _pulseAnimation.value,
                                          ),
                                          BoxShadow(
                                            color: AppColors.primaryBlue
                                                .withValues(
                                              alpha:
                                                  0.3 * _pulseAnimation.value,
                                            ),
                                            blurRadius:
                                                60 * _pulseAnimation.value,
                                            spreadRadius:
                                                15 * _pulseAnimation.value,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: AppColors.white
                                              .withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.white
                                                .withValues(alpha: 0.3),
                                            width: 2,
                                          ),
                                        ),
                                        child: Image.asset(
                                          'assets/drawables/app_logo.png',
                                          width: isSmallScreen ? 100 : 140,
                                          height: isSmallScreen ? 100 : 140,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: isSmallScreen ? 32 : 48),
                            // App Name
                            AnimatedBuilder(
                              animation: _mainAnimationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _textSlideAnimation.value),
                                  child: FadeTransition(
                                    opacity: _textFadeAnimation,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "RNAG",
                                          style: heading01.copyWith(
                                            color: AppColors.white,
                                            fontSize: isSmallScreen ? 32 : 42,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 2.0,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 10,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                            height: isSmallScreen ? 12 : 16),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.1,
                                          ),
                                          child: Text(
                                            "Your garage. Your rules.",
                                            style: subText16M.copyWith(
                                              color: AppColors.white
                                                  .withValues(alpha: 0.95),
                                              fontSize: isSmallScreen ? 15 : 18,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.8,
                                              height: 1.4,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Loading indicator
                    AnimatedBuilder(
                      animation: _loadingAnimationController,
                      builder: (context, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.4,
                              child: LinearProgressIndicator(
                                value: _loadingProgressAnimation.value,
                                backgroundColor:
                                    AppColors.white.withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white.withValues(alpha: 0.8),
                                ),
                                minHeight: 3,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                color: AppColors.white.withValues(alpha: 0.7),
                                fontSize: isSmallScreen ? 12 : 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: isSmallScreen ? 24 : 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
