import 'dart:async';
import 'package:brick_hold_em/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
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
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    // Use a standard MaterialPageRoute so that the Hero transition works.
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AuthService().handleAuthStateNew()));
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
        // Wrap the logo in a Hero widget with the tag 'logoHero'
        child: Hero(
          tag: 'logoHero',
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/BrickHoldEmLogo.png',
              width: 150,
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}