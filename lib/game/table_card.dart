import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableCard extends ConsumerStatefulWidget {
  const TableCard({
    Key? key,
    required this.child,
    this.controller,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
  }) : super(key: key);
  final Widget child;
  final Duration duration;
  final double deltaX;
  final Curve curve;
  final Function(AnimationController)? controller;

  @override
  _TableErrorState createState() => _TableErrorState();
}

class _TableErrorState extends ConsumerState<TableCard>
    with SingleTickerProviderStateMixin<TableCard> {
  late AnimationController controller;
  late Animation<double> offsetAnimation;

  late Animation<double>offsetAnimation2;
  


  @override
  void initState() {
    controller = AnimationController(duration: widget.duration, vsync: this)..forward();
    offsetAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: widget.curve))
        .animate(controller)..addStatusListener((status) { 
          if (status == AnimationStatus.completed) {
            controller.reset();
            ref.read(isThereAnInvalidPlayProvider.notifier).state = false;
            //print("okay we here");
          } 
        });
    if (widget.controller is Function) {
      widget.controller!(controller);
    }

    offsetAnimation2 = Tween<double>(begin: 0.0, end: 0.0)
        .chain(CurveTween(curve: widget.curve))
        .animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - widget.curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    
    return AnimatedBuilder(
      animation: offsetAnimation, 
      builder: (BuildContext context, Widget? child) {
        if(ref.watch(isThereAnInvalidPlayProvider)){
          //print("HIIIII");
          return Transform.translate(
          offset: Offset(widget.deltaX * shake(offsetAnimation.value), 0),
          child: child,
        );
        } else {
          //print("BYEEE");
          return SizedBox(child: child);
        }
      },
      child: widget.child,
    );
  }
}
