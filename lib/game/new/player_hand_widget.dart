import 'package:brick_hold_em/game/new/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_hold_em/providers/hand_notifier.dart';

class PlayerHandWidget extends ConsumerWidget {
  const PlayerHandWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hand = ref.watch(handProvider);

    // If the hand is empty, assume it's still loading.
    if (hand.isEmpty) {
      return const Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: SizedBox.shrink(),
      );
    }

    // Build card widgets from the list of CardKey objects.
    List<Widget> cardWidgets = hand.map((cardKey) {
      return CardWidget(
        key: ValueKey('card_${cardKey.position}_${cardKey.cardName}'),
        cardKey: cardKey,
      );
    }).toList();

    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cardWidgets,
          ),
        ),
      ),
    );
  }
}
