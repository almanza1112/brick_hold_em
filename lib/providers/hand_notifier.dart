import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_hold_em/game/card_key.dart';

class HandNotifier extends StateNotifier<List<CardKey>> {
  HandNotifier() : super([]) {
    _fetchHand();
  }

  Future<void> _fetchHand() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final handRef =
        FirebaseDatabase.instance.ref('tables/1/cards/playerCards/$uid/hand');
    final snapshot = await handRef.get();

    if (snapshot.exists) {
      final cards = <CardKey>[];
      int index = 0;

      // snapshot.children are in ascending push-key order
      for (final child in snapshot.children) {
        final cardName = child.value as String;
        final isBrick = cardName == 'brick';
        cards.add(
          CardKey(position: index, cardName: cardName, isBrick: isBrick),
        );
        index++;
      }

      state = cards;
    }
  }

  /// Shuffles the hand locally.
  void shuffleHand() {
    final newHand = [...state];
    newHand.shuffle();
    state = newHand;
  }

  void removeCard(CardKey card) {
    final newHand = [...state];
    newHand.removeWhere((element) => element == card);
    state = newHand;
  }

  void addCard(CardKey card) {
    state = [...state, card];
  }

  /// Clears the hand. You can also call _fetchHand() after clearing if needed.
  void resetHand() {
    state = [];
  }
}

final handProvider = StateNotifierProvider<HandNotifier, List<CardKey>>(
  (ref) => HandNotifier(),
);
