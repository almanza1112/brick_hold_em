import 'dart:async';

import 'package:brick_hold_em/game/turn_player_progress_indicator.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:brick_hold_em/game/progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameTurnTimer extends ConsumerStatefulWidget {
  const GameTurnTimer({super.key});

  @override
  GameTurnTimerState createState() => GameTurnTimerState();
}

class GameTurnTimerState extends ConsumerState {
  TextStyle turnPlayerTextStyle = const TextStyle(
      color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold);

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Timer? _timer;

  bool _isDisposed = false;

  @override
  Widget build(BuildContext context) {
    return turnPlayerTimer();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); //
    _isDisposed = true; // Set the flag when the widget is disposed
    super.dispose();
  }

  Widget turnPlayerTimer() {
    int countdown = 30;

    final liveTurnPlayer = ref.watch(turnPlayerProvider);

    return liveTurnPlayer.when(
        data: (event) {
          final turnPlayerPosition = event.snapshot.value as int;
          final playerPosition = ref.read(playerPositionProvider);

          //print("playerPosition: ${playerPosition}");

          if (turnPlayerPosition == playerPosition) {
            // Update the StateProvider
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Updating if it is the players turn to true
              ref.read(isPlayersTurnProvider.notifier).state = true;

              // Updating if the player added a card this turn to false
              ref.read(didPlayerAddCardThisTurnProvider.notifier).state = false;

            });

            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StatefulBuilder(builder: (context, setState) {
                // Sound for the countdown
                SystemSound.play(SystemSoundType.click);
                // Vibration for the countdown
                HapticFeedback.heavyImpact();

                if (countdown > 0) {
                  _timer = Timer(const Duration(seconds: 1), () {
                    if (_isDisposed) {
                      // Check if the widget is disposed before updating the state
                      _timer?.cancel();
                      return;
                    }
                    setState(() {
                      countdown--;
                      // if (countdown <= 0) {
                      //   // TODO: APPLY THIS LOGIC
                      //   // ranOutOfTime();
                      //   _timer?.cancel();
                      // }
                    });
                  });
                } else {
                  // TODO: APPLY THIS LOGIC
                  //ranOutOfTime();
                }

                return Stack(
                  children: [
                    const TurnPlayerProgressIndicator(),
                    Center(
                      child: Text(
                        "$countdown",
                        style: turnPlayerTextStyle,
                      ),
                    )
                  ],
                );
              }),
            );
          } else {
            // Update the StateProvider
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Updating if it is the players turn to false
              ref.read(isPlayersTurnProvider.notifier).state = false;

              // Updating if the player added a card this turn to true as a
              // precaution
              ref.read(didPlayerAddCardThisTurnProvider.notifier).state = true;
            });

            num position =
                (turnPlayerPosition - ref.read(playerPositionProvider)) - 1;

            //print("positionAfterSub: $position");

            if (position < 0) {
              position = 6 + position;
            }
            return Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 55,
              child: Stack(
                children: [
                  SizedBox(
                    // Got this number by subtracting 'top' num above with height of players sizedbox which is 550
                    height: 495,
                    child: Stack(
                      children: [
                        ProgressIndicatorTurn(
                          position: position as int,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 30,
                        color: Colors.red,
                        child: const Center(
                            child: Text(
                          "WAITING...",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        )),
                      )),
                ],
              ),
            );
          }
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => const CircularProgressIndicator());
  }
}
