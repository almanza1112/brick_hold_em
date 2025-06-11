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
          IconButton(
            onPressed: () => ref.read(handProvider.notifier).shuffleHand(),
            icon: const Icon(Icons.shuffle, color: Colors.amber, size: 36),
          ),
          IconButton(
            onPressed: () => ref.read(gameServiceProvider).play(ref, context),
            icon: const Icon(Icons.play_arrow, color: Colors.amber, size: 36),
          ),
        ],
      ),
    );
  }
}
