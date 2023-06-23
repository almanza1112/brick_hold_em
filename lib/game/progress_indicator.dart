
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorTurn extends StatefulWidget {
  const ProgressIndicatorTurn({super.key});

  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicatorTurn>
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
    controller.repeat(reverse: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("progress indicator");
    return Center(
      child: SizedBox(
        height: 450,
        child: Stack(
          children: [
            Positioned(
              bottom: 35,
              right: 20,
              child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  value: controller.value,
                  valueColor: colorTween,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
