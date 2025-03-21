import 'package:brick_hold_em/game/server_linear_progress_indicator_turn.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UnifiedTurnTimer shows the circular progress indicator if it is your turn;
/// otherwise, it shows a "WAITING..." message.
class GameTurnTimer extends ConsumerWidget {
  const GameTurnTimer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the current turn (turnPlayer) from Firebase.
    final turnPlayerAsync = ref.watch(turnPlayerProvider);
    // Get the local player's position.
    final int playerPosition = ref.watch(playerPositionProvider);

    return turnPlayerAsync.when(
      data: (event) {
        // Assume turnPlayer is stored as an int.
        final int currentTurn = event.snapshot.value as int;
        if (currentTurn == playerPosition) {
          return ServerLinearProgressIndicatorTurn();
        } else {
          // It's not your turn: show a waiting message.
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              color: Colors.red,
              child: const Center(
                child: Text(
                  "WAITING...",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
            ),
          );
        }
      },
      error: (error, stack) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
