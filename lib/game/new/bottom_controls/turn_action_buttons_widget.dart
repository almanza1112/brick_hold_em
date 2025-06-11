import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:brick_hold_em/providers/hand_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------------------
/// Turn Action Buttons Widget
/// ------------------------
class TurnActionButtonsWidget extends ConsumerWidget {
  const TurnActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We already know bottomState == myTurn, so just render:
    return Positioned(
      bottom: 40,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 5),
              backgroundColor: Colors.black,
              foregroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.amber, width: 1.0),
              ),
            ),
            child: Text(
              'SHUFFLE',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            onPressed: () {
              ref.read(handProvider.notifier).shuffleHand();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 5),
              backgroundColor: Colors.black,
              foregroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.amber, width: 1.0),
              ),
            ),
            child: Text(
              'PLAY',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            onPressed: () {
              ref.read(gameServiceProvider).play(ref, context);
            },
          ),
        ],
      ),
    );
  }
}
