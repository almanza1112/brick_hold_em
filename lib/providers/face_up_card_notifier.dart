import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaceUpCardNotifier extends StateNotifier<String> {
  late final StreamSubscription _subscription;
  
  FaceUpCardNotifier() : super('') {
    // Listen to the discardPile for the latest face-up card.
    final ref = FirebaseDatabase.instance
        .ref('tables/1/cards/discardPile')
        .limitToLast(1);
    
    _subscription = ref.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final key = data.keys.first;
        final List<dynamic> cards = data[key];
        state = cards.last.toString();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Provider that exposes the latest face-up card.
final faceUpCardCacheProvider =
    StateNotifierProvider<FaceUpCardNotifier, String>(
        (ref) => FaceUpCardNotifier());