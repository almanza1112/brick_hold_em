import 'package:flutter/material.dart';

class BouncingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const BouncingIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  _BouncingIconState createState() => _BouncingIconState();
}

class _BouncingIconState extends State<BouncingIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Set up a looping animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this
    )..repeat();

    //_controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + 0.5 * _controller.value, // Adjust the amplitude as needed
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
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
