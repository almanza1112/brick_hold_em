import 'package:flutter/material.dart';

/// ------------------------
/// Animated Chips Widget
/// ------------------------
/// Shows an animated casino chips image moving from the player’s chips to the table.
class AnimatedChipsWidget extends StatelessWidget {
  final bool visible;
  final double startPosY;
  final VoidCallback onAnimationEnd;
  const AnimatedChipsWidget({
    super.key,
    required this.visible,
    required this.startPosY,
    required this.onAnimationEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: AnimatedPositioned(
        left: MediaQuery.of(context).size.width / 2 - 25,
        bottom: startPosY,
        duration: const Duration(milliseconds: 500),
        onEnd: onAnimationEnd,
        child: Image.asset('assets/images/casino-chips.png', width: 50),
      ),
    );
  }
}