// File: player_hand_widget.dart
import 'package:brick_hold_em/game/card_key.dart';
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

    // Convert the list of card names to a list of CardKey objects.
    List<CardKey> cards = [];
    for (int i = 0; i < hand.length; i++) {
      bool isBrick = hand[i] == 'brick';
      cards.add(CardKey(position: i, cardName: hand[i], isBrick: isBrick));
    }

    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return CardWidget(
              key: ValueKey('card_${cards[index].position}_${cards[index].cardName}'),
              cardKey: cards[index],
            );
          },
        ),
      ),
    );
  }
}