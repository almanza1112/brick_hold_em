import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/player.dart';

final faceUpCardProvider = StreamProvider<DatabaseEvent>((ref) {
  // DatabaseReference faceUpCardRef =
  //     FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');

  Query faceUpCardRef = FirebaseDatabase.instance.ref('tables/1/cards/discardPile').limitToLast(1);
  return faceUpCardRef.onValue;
});

final turnPlayerProvider = StreamProvider<DatabaseEvent>((ref) {
  DatabaseReference turnPlayerRef =
      FirebaseDatabase.instance.ref('tables/1/turnOrder/turnPlayer');

  return turnPlayerRef.onValue;
});

final winnerProvider = StreamProvider<DatabaseEvent>((ref){
  DatabaseReference winnerRef = FirebaseDatabase.instance.ref('tables/1/winner');

  return winnerRef.onValue;
});

final isThereAWinnerProvider = StateProvider<bool>((ref) => false);

final otherPlayersInformationProvider = StateProvider<List<Player>>((ref) => []);

final otherPlayersAdjustedPositionsProvider = StateProvider<List<int>>((ref) => [],);

final playerPositionProvider = StateProvider<int>((ref) => 20);

final isPlayersTurnProvider = StateProvider<bool>(((ref) => false));

final didPlayerAddCardThisTurnProvider = StateProvider<bool>((ref) => true);

final isPlayButtonSelectedProvider = StateProvider<bool>((ref) => false);

final brickCardSuitProvider = StateProvider<String>((ref) => 'spades');

final brickCardNumberProvider = StateProvider<String>((ref) => 'Ace');


