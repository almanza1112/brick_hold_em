import 'package:brick_hold_em/game/new/bottom_controls/game_turn_timer.dart';
import 'package:brick_hold_em/game/new/bottom_controls/turn_action_buttons_widget.dart';
import 'package:brick_hold_em/game/new/bottom_controls/waiting_action_buttons_widget.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomControls extends ConsumerWidget {
  const BottomControls({super.key});

  @override
  Widget build(context, WidgetRef ref) {
    final state = ref.watch(bottomStateProvider);
    switch (state) {
      case BottomState.needToCall:
        return _buildSkipButton(ref);
      case BottomState.myTurn:
        return const TurnActionButtonsWidget();
      case BottomState.waiting:
        return const WaitingActionButtonsWidget();
      default:
        return const GameTurnTimer();
    }
  }
}

Widget _buildSkipButton(WidgetRef ref) {
  final gameService = ref.read(gameServiceProvider);

  return Positioned(
    bottom: 40,
    left: 10,
    right: 10,
    child: IconButton(
      icon: const Icon(Icons.skip_next, size: 36),
      color: Colors.amber,
      onPressed: () {
        gameService.skipPlayerTurn();
      },
    ),
  );
}
