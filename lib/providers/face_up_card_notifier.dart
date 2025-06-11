import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaceUpCardNotifier extends StateNotifier<String> {
  late final StreamSubscription<DatabaseEvent> _subscription;
  
  FaceUpCardNotifier() : super('') {
    final ref = FirebaseDatabase.instance
        .ref('tables/1/cards/discardPile')
        .limitToLast(1);

    // Listen for the newest child
    _subscription = ref.onChildAdded.listen((event) {
      final val = event.snapshot.value;
      if (val != null) {
        state = val.toString();
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