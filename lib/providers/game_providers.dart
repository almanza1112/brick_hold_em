import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final faceUpCardProvider = StreamProvider<DatabaseEvent>((ref) {
  DatabaseReference faceUpCardRef =
      FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');

  return faceUpCardRef.onValue;
});


final turnPlayerProvider = StreamProvider<DatabaseEvent>((ref) {
  DatabaseReference turnPlayerRef =
      FirebaseDatabase.instance.ref('tables/1/turnOrder/turnPlayer');

  return turnPlayerRef.onValue;
});

final otherPlayersAdjustedPositionsProvider = StateProvider<List<int>>((ref) => [],);

final playerPositionProvider = StateProvider<int>((ref) => 20);

final isPlayersTurnProvider = StateProvider<bool>(((ref) => false));

final didPlayerAddCardThisTurnProvider = StateProvider<bool>((ref) => true);

final isPlayButtonSelectedProvider = StateProvider<bool>((ref) => false);


