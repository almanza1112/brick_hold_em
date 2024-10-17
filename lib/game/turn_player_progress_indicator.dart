import 'package:flutter/material.dart';

class TurnPlayerProgressIndicator extends StatefulWidget {
  const TurnPlayerProgressIndicator({super.key});

  @override
  State<TurnPlayerProgressIndicator> createState() =>
      _TurnPlayerProgressIndicatorState();
}

class _TurnPlayerProgressIndicatorState
    extends State<TurnPlayerProgressIndicator> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.forward(); // Start the animation when the widget is first built
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: controller.value,
      semanticsLabel: 'Linear progress indicator',
      valueColor:
          const AlwaysStoppedAnimation<Color>(Colors.blue), // Customize the color
      backgroundColor: Colors.grey, // Customize the background color
      minHeight: 35, // Adjust the height to make it thicker
    );
  }
}
