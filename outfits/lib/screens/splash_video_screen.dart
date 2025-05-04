import 'package:flutter/material.dart';

import 'dart:async';
import 'package:outfits/screens/screens.dart';

class SplashVideoScreen extends StatefulWidget {
  const SplashVideoScreen({super.key});

  @override
  State<SplashVideoScreen> createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();

    // Configuración del controlador de animación
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Animación de escala inicial
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    // Animación de fade-in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    // Animación de latido del corazón (2 pulsaciones)
    _heartbeatAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.05), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 0.95), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.95, end: 1.0), weight: 20),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Inicia la animación
    _controller.forward();

    // Navega al home después de 3.5 segundos
    Timer(const Duration(milliseconds: 4500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200),
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var slideTween = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            );
            var slideAnimation = slideTween.animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutQuad,
            ));
            
            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
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
      body: Stack(
        children: [
          // Fondo de pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/fondo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay semi-transparente
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo con animaciones combinadas
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _heartbeatAnimation,
                          child: Image.asset(
                            'assets/logo.png',
                            width: 200, // Tamaño reducido del logo
                            height: 100, // Tamaño reducido del logo
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}