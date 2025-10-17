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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F), // Negro profundo
      body: Stack(
        children: [
          // 🔹 LOGO centrado perfectamente
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
                            const Color(0xFF7A00FF),
                            const Color(0xFF00E5FF),
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

          // 🔹 Pie de página centrado horizontalmente
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'Desarrollado por: Aguirre y Díaz',
                textAlign: TextAlign.center, // ✅ Centrado
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.8,
                  shadows: [
                    Shadow(
                      color: Color(0xFF7A00FF),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: Color(0xFF00E5FF),
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
