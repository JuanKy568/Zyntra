import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = isDark ? Colors.grey[300] : Colors.grey[800];
    final primaryGlow = isDark ? const Color(0xFF7A00FF) : const Color(0xFF6200EA);
    final secondaryGlow = isDark ? const Color(0xFF00E5FF) : const Color(0xFF03A9F4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 🔹 LOGO con efecto de brillo
          Center(
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.lerp(
                            primaryGlow,
                            secondaryGlow,
                            _glowAnimation.value,
                          )!
                              .withOpacity(0.6),
                          blurRadius: 25 * _glowAnimation.value,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/logo.png',
                  width: 210,
                  height: 210,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // 🔹 Texto inferior
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Desarrollado por: Aguirre y Díaz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.8,
                  shadows: [
                    Shadow(
                      color: primaryGlow.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: secondaryGlow.withOpacity(0.8),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
