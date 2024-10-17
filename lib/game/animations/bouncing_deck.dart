import 'package:flutter/material.dart';

class BouncingDeck extends StatefulWidget {
  final double width;
  final double height;

  const BouncingDeck({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<BouncingDeck> createState() => _BouncingDeckState();
}

class _BouncingDeckState extends State<BouncingDeck>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Set up a looping animation controller that reverses back to original size
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800), 
      vsync: this,
    )..repeat(reverse: true); // Repeat with reverse motion
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale:
              1.0 + 0.3 * _controller.value, // Adjust the amplitude as needed
          child: Image.asset(
            "assets/images/backside.png",
            fit: BoxFit.cover,
            width: widget.width,
            height: widget.height,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}