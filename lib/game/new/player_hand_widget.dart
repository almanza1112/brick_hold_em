// File: player_hand_widget.dart
import 'package:brick_hold_em/game/new/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_hold_em/providers/hand_notifier.dart';

class PlayerHandWidget extends ConsumerWidget {
  const PlayerHandWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hand = ref.watch(handProvider);
    
    // If the hand is empty, we assume it is still loading.
    if (hand.isEmpty) {
      return const Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: hand.length,
          itemBuilder: (context, index) {
            return CardWidget(
              key: ValueKey('card_${hand[index].position}_${hand[index].cardName}'),
              cardKey: hand[index],
            );
          },
        ),
      ),
    );
  }
}