import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'counter_screen.dart';
import '../l10n/app_localizations.dart';
import '../widgets/premium_app_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Slide-in from top
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  // Slow floating after landing
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  // Fade-in for title + tagline
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // Subtle rotation
  late final AnimationController _rotateController;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Slide from top
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 2. Gentle float (up/down loop)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // 3. Fade in text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // 4. Subtle rotation (±2°)
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _rotateAnimation = Tween<double>(
      begin: -0.04,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations immediately on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _slideController.forward().then((_) {
        if (!mounted) return;
        _floatController.repeat(reverse: true);
        _rotateController.forward();
        _fadeController.forward();
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _floatController.dispose();
    _fadeController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.72;
    final l10n = AppLocalizations.of(context);

    return PremiumAppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Main content ─────────────────────────────────────
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Glow + tasbeeh image
                SlideTransition(
                  position: _slideAnimation,
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: child,
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) => Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: child,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow circle behind image
                          Container(
                            width: imageSize * 0.9,
                            height: imageSize * 0.9,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF55E16B).withOpacity(0.25),
                                  blurRadius: 80,
                                  spreadRadius: 20,
                                ),
                                BoxShadow(
                                  color: const Color(0xFFE9C349).withOpacity(0.12),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          // Tasbeeh image
                          Image.asset(
                            'assets/tasbeeh.png',
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title + tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Digital Tasbeeh',
                        style: TextStyle(
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.translate('count_your_dhikr'),
                        style: TextStyle(
                          fontSize: size.width * 0.038,
                          color: Colors.white.withOpacity(0.65),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // Continue button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 28,
                      right: 28,
                      bottom: 52,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const CounterScreen(),
                            transitionsBuilder: (_, animation, __, child) =>
                                FadeTransition(opacity: animation, child: child),
                            transitionDuration: const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2ECC71), Color(0xFF1A9E50)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2ECC71).withOpacity(0.45),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.translate('continue_text'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// GeometricPatternPainter is defined in lib/widgets/premium_app_background.dart
