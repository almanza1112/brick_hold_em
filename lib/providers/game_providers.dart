import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/player.dart';

final faceUpCardProvider = StreamProvider<DatabaseEvent>((ref) {
  Query faceUpCardRef = FirebaseDatabase.instance
      .ref('tables/1/cards/discardPile')
      .limitToLast(1);

  return faceUpCardRef.onValue;
});

final turnPlayerProvider = StreamProvider<DatabaseEvent>((ref) {
  DatabaseReference turnPlayerRef =
      FirebaseDatabase.instance.ref('tables/1/turnOrder/turnPlayer');

  return turnPlayerRef.onValue;
});

final winnerProvider = StreamProvider<DatabaseEvent>((ref) {
  DatabaseReference winnerRef =
      FirebaseDatabase.instance.ref('tables/1/winner');

  return winnerRef.onValue;
});

final refreshKeyProvider = StateProvider<UniqueKey>((ref) => UniqueKey());

final isThereAWinnerProvider = StateProvider<bool>((ref) => false);

final otherPlayersInformationProvider =
    StateProvider<List<Player>>((ref) => []);

final otherPlayersAdjustedPositionsProvider = StateProvider<List<int>>(
  (ref) => [],
);

final playerPositionProvider = StateProvider<int>((ref) => 20);

final isPlayersTurnProvider = StateProvider<bool>(((ref) => false));

final didPlayerAddCardThisTurnProvider = StateProvider<bool>((ref) => true);

final isPlayButtonSelectedProvider = StateProvider<bool>((ref) => false);

final brickCardSuitPositionProvider = StateProvider<int>((ref) => 0);

final brickCardNumberPositionProvider = StateProvider<int>((ref) => 0);

final playerChipCountProvider = StateProvider<double>((ref) => 0);

// TODO: no idea why i made this or the thought behind it
final chipsValueProvider = StateProvider<double>((ref) => 0);

// BETTING

final isThereABetProvider = StateProvider<bool>((ref) => false);

final typeOfBetProvider = StateProvider<String>((ref) => "check");

final doYouNeedToCallProvider = StateProvider<bool>((ref) => false);

final toCallAmmount = StateProvider<String>((ref) => "0");

final isFoldSelectedProvider = StateProvider<bool>((ref) => false);

final isRaiseSelectedProvider = StateProvider<bool>((ref) => false);

final isCallCheckSelectedProvider = StateProvider<bool>((ref) => false);

final isThereAnInvalidPlayProvider = StateProvider<bool>((ref) => false);


// BLINDS
final userBlindProvider = StateProvider<String>((ref) => "none");