import 'package:brick_hold_em/game/animations/bouncing_deck.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeckCard extends ConsumerWidget {
  const DeckCard({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double tableCardWidth = 40;
    double tableCardHeight = 56;
    
    if (ref.watch(isPlayersTurnProvider)) {
      if (ref.read(didPlayerAddCardThisTurnProvider)) {
        return Image.asset(
          "assets/images/backside.png",
          fit: BoxFit.cover,
          width: tableCardWidth,
          height: tableCardHeight,
        );
      } else {
        return BouncingDeck(width: tableCardWidth, height: tableCardHeight);
      }
    } else {
      return Image.asset(
        "assets/images/backside.png",
        fit: BoxFit.cover,
        width: tableCardWidth,
        height: tableCardHeight,
      );
    }
  }

  
}
