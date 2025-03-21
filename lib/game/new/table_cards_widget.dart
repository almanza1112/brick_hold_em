import 'package:brick_hold_em/game/new/deck_widget.dart';
import 'package:brick_hold_em/game/new/face_up_card_widget.dart';
import 'package:brick_hold_em/game/new/table_card_widget.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------------------
/// Table Cards Widget
/// ------------------------
/// This widget is responsible for displaying the deck, table cards positions,
/// and table chips.
// TableCardsWidget builds the table layout (red dot borders, face-up card, animated table cards, and deck).
class TableCardsWidget extends ConsumerWidget {
  final BoxConstraints constraints;
  const TableCardsWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double tableCardWidth = 40;
    double tableCardHeight = 56;
    double tableCardsYPos = 350;
    // For brevity, we show one red dot; you would repeat similar code for positions 2–5.
    return Stack(
      children: [
        // Example red dot
        Positioned(
          top: tableCardsYPos,
          left: (constraints.maxWidth / 2) - ((tableCardWidth * 2) + 10),
          child: const SizedBox(
              height: 70,
              width: 50,
              child: Center(
                  child:
                      Icon(Icons.circle_sharp, color: Colors.red, size: 12))),
        ),
        // Face-up card widget
        Positioned(
          top: tableCardsYPos,
          left: (constraints.maxWidth / 2) - ((tableCardWidth * 2) + 10),
          child: FaceUpCardWidget(
              tableCardWidth: tableCardWidth, tableCardHeight: tableCardHeight),
        ),
        // Animated table cards at positions 0-3
        AnimatedPositioned(
          top: tableCardsYPos,
          left: ref.read(isPlayButtonSelectedProvider)
              ? (constraints.maxWidth / 2) - ((tableCardWidth * 2) + 10)
              : (constraints.maxWidth / 2) - ((tableCardWidth * 1) + 5),
          duration: const Duration(milliseconds: 250),
          child: SizedBox(
              height: tableCardHeight,
              width: tableCardWidth,
              child: TableCardWidget(cardIndex: 0)),
        ),
        AnimatedPositioned(
          top: tableCardsYPos,
          left: ref.read(isPlayButtonSelectedProvider)
              ? (constraints.maxWidth / 2) - ((tableCardWidth * 2) + 10)
              : (constraints.maxWidth / 2),
          duration: const Duration(milliseconds: 250),
          child: SizedBox(
              height: tableCardHeight,
              width: tableCardWidth,
              child: TableCardWidget(cardIndex: 1)),
        ),
        AnimatedPositioned(
          top: tableCardsYPos,
          left: ref.read(isPlayButtonSelectedProvider)
              ? (constraints.maxWidth / 2) - ((tableCardWidth * 2) + 10)
              : (constraints.maxWidth / 2) + ((tableCardWidth * 1) + 5),
          duration: const Duration(milliseconds: 250),
          child: SizedBox(
              height: tableCardHeight,
              width: tableCardWidth,
              child: TableCardWidget(cardIndex: 2)),
        ),
        AnimatedPositioned(
          top: tableCardsYPos,
          left: ref.read(isPlayButtonSelectedProvider)
              ? (constraints.maxWidth / 2) - ((tableCardWidth * 2) + 10)
              : (constraints.maxWidth / 2) + ((tableCardWidth * 2) + 10),
          duration: const Duration(milliseconds: 250),
          child: SizedBox(
              height: tableCardHeight,
              width: tableCardWidth,
              child: TableCardWidget(cardIndex: 3)),
        ),
        // Deck widget
        Positioned(
          top: tableCardsYPos,
          left: (constraints.maxWidth / 2) - ((tableCardWidth * 3) + 20),
          child: DeckWidget(),
        ),
      ],
    );
  }
}
