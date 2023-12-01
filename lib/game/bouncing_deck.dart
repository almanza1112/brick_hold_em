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
  _BouncingDeckState createState() => _BouncingDeckState();
}

class _BouncingDeckState extends State<BouncingDeck>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Set up a looping animation controller
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..repeat();

    //_controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale:
              1.0 + 0.5 * _controller.value, // Adjust the amplitude as needed
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
