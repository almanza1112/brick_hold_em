import 'package:flutter/material.dart';

class ProgressIndicatorTurn extends StatefulWidget {
  final int position;
  const ProgressIndicatorTurn({super.key, required this.position});

  @override
  ProgressIndicatorState createState() => ProgressIndicatorState();
}

class ProgressIndicatorState extends State<ProgressIndicatorTurn>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> colorTween;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 3),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //changeTurnPlayer();
        }
      });

    colorTween =
        controller.drive(ColorTween(begin: Colors.black, end: Colors.red));
    //controller.repeat(reverse: false);
    controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    bool top = false, bottom = false, right = false, left = false;
    late double topNum, leftNum, rightNum;
    switch (widget.position) {
      case 0:
        // Bottom right
        bottom = true;
        right = true;
        rightNum = 20;
        break;

      case 1:
        // Top right
        top = true;
        right = true;
        topNum = 125;
        rightNum = 20;
        break;

      case 2:
        // Top center
        top = true;
        right = true;
        left = true;
        topNum = 0;
        leftNum = 0;
        rightNum = 0;
        break;

      case 3:
        // Top left
        top = true;
        left = true;
        topNum = 125;
        leftNum = 20;
        break;

      case 4:
        // Bottom left
        bottom = true;
        left = true;
        leftNum = 20;
        break;
    }

    if (widget.position == 2) {
      return Align(
        alignment: Alignment.topCenter,
        child: Transform(
          transform: Matrix4.translationValues(0, -5, 0),
          child: SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              strokeWidth: 10,
              value: controller.value,
              valueColor: colorTween,
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        top: top ? topNum : null,
        right: right ? rightNum : null,
        left: left ? leftNum : null,
        bottom: bottom ? 35 : null, // Must be same height as SizedBox in game_turn_timer
        child: SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            strokeWidth: 10,
            value: controller.value,
            valueColor: colorTween,
          ),
        ),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
