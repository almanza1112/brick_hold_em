// File: table_card_widget.dart
import 'package:brick_hold_em/game/table_card.dart';
import 'package:brick_hold_em/game/new/card_widget.dart';
import 'package:brick_hold_em/providers/tapped_cards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableCardWidget extends ConsumerWidget {
  final int cardIndex;
  const TableCardWidget({super.key, required this.cardIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // tappedCardsProvider holds a list of CardKey objects representing tapped cards.
    final tappedCards = ref.watch(tappedCardsProvider);
    if (cardIndex < tappedCards.length) {
      // Build a CardWidget using the tapped card's CardKey
      return TableCard(
        child: CardWidget(cardKey: tappedCards[cardIndex]),
      );
    }
    return Container();
  }
}