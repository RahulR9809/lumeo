import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/auth-check");
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
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               ClipOval(
      child: Image.asset(
        'assets/icon.png',
        height: 120,
        width: 120,
        fit: BoxFit.cover,
      ),
    ),
              const SizedBox(height: 20),
      
            ],
          ),
        ),
      ),
    );
  }
}
