// File: game_countdown.dart
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameCountdown extends ConsumerWidget {
  const GameCountdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextGameStartAsync = ref.watch(nextGameStartProvider);

    return nextGameStartAsync.when(
      data: (nextGameStart) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final remainingSeconds = ((nextGameStart - now) / 1000).ceil();

        if (remainingSeconds <= 0) {
          // When countdown reaches zero, you might trigger your game reset logic.
          // For example:
          // ref.read(gameResetProvider.notifier).resetGame();
          return const SizedBox.shrink();
        }

        return Text(
          "New game starts in $remainingSeconds seconds",
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text("Error: $e"),
    );
  }
}