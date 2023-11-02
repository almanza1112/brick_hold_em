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
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: controller.value,
      semanticsLabel: 'Linear progress indicator',
    );
  }
}
