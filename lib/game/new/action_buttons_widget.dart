import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:brick_hold_em/providers/hand_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------------------
/// Action Buttons Widget
/// ------------------------
/// This widget shows the buttons for shuffle, pass, play, and bet. It replicates
/// the logic from your original `buttons()` method.
class ActionButtonsWidget extends ConsumerWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveTurnPlayerAsyncValue = ref.watch(turnPlayerProvider);
    final playerPosition = ref.read(playerPositionProvider);
    const double leftPosition = 10;
    const double rightPosition = 10;

    return liveTurnPlayerAsyncValue.when(
      data: (event) {
        final turnPlayerPosition = event.snapshot.value;
        if (turnPlayerPosition == playerPosition) {
          // It is the player's turn. Show full buttons.
          return Positioned(
            bottom: 40,
            left: leftPosition,
            right: rightPosition,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Shuffle button
                  IconButton(
                    onPressed: () => _shuffleHandButton(ref),
                    icon: const Icon(
                      Icons.shuffle,
                      color: Colors.amber,
                      size: 36,
                    ),
                  ),
                  // Pass button
                  // IconButton(
                  //   onPressed: () => _passButton(ref),
                  //   icon: const Icon(
                  //     Icons.check,
                  //     color: Colors.amber,
                  //     size: 36,
                  //   ),
                  // ),
                  // Play button
                  IconButton(
                    onPressed: () => _playButton(ref, context),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.amber,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // It is not the player's turn; only show shuffle and bet button.
          return Positioned(
            bottom: 40,
            left: leftPosition,
            right: rightPosition,
            child: IconButton(
              onPressed: () => _shuffleHandButton(ref),
              icon: const Icon(
                Icons.shuffle,
                color: Colors.amber,
                size: 36,
              ),
            ),
          );
        }
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(child: CircularProgressIndicator())),
    );
  }

  // TODO:
  // These helper methods replicate the logic from my original code.
  // In a complete refactoring I would ideally move these into your GameService.

  void _shuffleHandButton(WidgetRef ref) {
    // Mark that a move has been made.
    //ref.read(didUserMoveCardProvider.notifier).state = true;
    // Shuffle the hand using the hand provider.
    ref.read(handProvider.notifier).shuffleHand();
    print("Shuffle hand pressed");
  }

  void _passButton(WidgetRef ref) {
    // Call the passPlay logic; for example, call your GameService.
    final gameService = ref.read(gameServiceProvider);
    gameService.passPlay();
    print("Pass play pressed");
  }

  void _playButton(WidgetRef ref, BuildContext context) {
    final gameService = ref.read(gameServiceProvider);
    gameService.play(ref, context);
  }
}
