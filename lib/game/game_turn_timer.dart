import 'dart:async';

import 'package:brick_hold_em/game/game_providers.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: <Widget>[
        turnPlayerTimer(),
      ],
    ));
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Widget turnPlayerTimer() {
    int countdown = 30;

    final liveTurnPlayer = ref.watch(turnPlayerProvider);

    return liveTurnPlayer.when(
        data: (event) {
          final turnPlayerPosition = event.snapshot.value as int;
          final playerPosition = ref.read(playerPositionProvider);

          if (turnPlayerPosition == playerPosition) {
            // Update the StateProvider
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(isPlayersTurnProvider.notifier).state = true;
              ref.read(didPlayerAddCardThisTurnProvider.notifier).state = true;
            });

            return Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: StatefulBuilder(builder: (context, setState) {
                // Sound for the countdown
                SystemSound.play(SystemSoundType.click);
                // Vibration for the countdown
                HapticFeedback.heavyImpact();

                if (countdown > 0) {
                  _timer = Timer(const Duration(seconds: 1), () {
                    setState(() {
                      countdown--;
                    });
                  });
                } else {
                  // TODO: APPLY THIS LOGIC
                  //ranOutOfTime();
                }

                return Column(
                  children: [
                    Text(
                      "IT'S YOUR TURN",
                      style: turnPlayerTextStyle,
                    ),
                    Text(
                      "$countdown",
                      style: turnPlayerTextStyle,
                    )
                  ],
                );
              }),
            );
          } else {
            // Update the StateProvider
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(isPlayersTurnProvider.notifier).state = false;
              ref.read(didPlayerAddCardThisTurnProvider.notifier).state = false;
            });

            num position =
                (turnPlayerPosition - ref.read(playerPositionProvider)) - 1;

            if (position < 0) {
              position = 6 + position;
            }
            return Center(
              child: SizedBox(
                height: 450,
                child: Stack(
                  children: [
                    ProgressIndicatorTurn(
                      position: position as int,
                    )
                  ],
                ),
              ),
            );
          }
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => const CircularProgressIndicator());
  }
}
