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
    final snapshot = await FirebaseDatabase.instance
        .ref('tables/1/cards/playerCards/$uid/hand')
        .get();
    if (snapshot.value != null) {
      final data = snapshot.value as List<dynamic>;
      final cards = <CardKey>[];
      for (var i = 0; i < data.length; i++) {
        bool isBrick = data[i] == 'brick';
        cards.add(CardKey(position: i, cardName: data[i], isBrick: isBrick));
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
}

final handProvider = StateNotifierProvider<HandNotifier, List<CardKey>>(
  (ref) => HandNotifier(),
);