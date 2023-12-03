import 'package:flutter/material.dart';

class BouncingText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  const BouncingText({Key? key, required this.text, required this.textStyle})
      : super(key: key);

  @override
  _BouncingTextState createState() => _BouncingTextState();
}

class _BouncingTextState extends State<BouncingText>
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
              1.0 + 0.2 * _controller.value, // Adjust the amplitude as needed
          child: Text(
            widget.text,
            style: widget.textStyle,
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
