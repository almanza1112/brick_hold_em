// File: hand_notifier.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HandNotifier extends StateNotifier<List<String>> {
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
      state = List<String>.from(data);
    }
  }

  /// Shuffles the hand locally.
  void shuffleHand() {
    final newHand = [...state];
    newHand.shuffle();
    state = newHand;
  }

  // In hand_notifier.dart
  void removeCard(String cardName) {
    final newHand = [...state];
    newHand.remove(cardName);
    state = newHand;
  }
}

// Provider for the hand.
final handProvider = StateNotifierProvider<HandNotifier, List<String>>(
  (ref) => HandNotifier(),
);
