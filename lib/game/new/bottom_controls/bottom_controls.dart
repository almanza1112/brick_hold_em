import 'package:brick_hold_em/game/new/bottom_controls/game_turn_timer.dart';
import 'package:brick_hold_em/game/new/bottom_controls/turn_action_buttons_widget.dart';
import 'package:brick_hold_em/game/new/bottom_controls/waiting_action_buttons_widget.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:brick_hold_em/providers/hand_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomControls extends ConsumerWidget {
  const BottomControls({super.key});

  @override
  Widget build(context, WidgetRef ref) {
    final state = ref.watch(bottomStateProvider);
    switch (state) {
      case BottomState.needToCall:
        return _needToCall(ref);
      case BottomState.myTurn:
        return const TurnActionButtonsWidget();
      case BottomState.waiting:
        return const WaitingActionButtonsWidget();
      default:
        return const GameTurnTimer();
    }
  }
}

Widget _needToCall(WidgetRef ref) {
  final gameService = ref.read(gameServiceProvider);

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
            padding: EdgeInsets.zero,
            backgroundColor: Colors.black,
            foregroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.amber, width: 1.0),
            ),
          ),
          child: Text(
            'FOLD',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          onPressed: () {},
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.black,
            foregroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.amber, width: 1.0),
            ),
          ),
          child: Text(
            'CALL',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          onPressed: () {
            gameService.skipPlayerTurn();
          },
        ),
      ],
    ),
  );
}
