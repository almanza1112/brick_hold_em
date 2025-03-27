import 'package:brick_hold_em/game/new/services/game_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/players/player.dart';

// TODO: remove this once you remove the old game_cards
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

// BETTING

final doYouNeedToCallProvider = StateProvider<bool>((ref) => false);

final isFoldSelectedProvider = StateProvider<bool>((ref) => false);

final isThereAnInvalidPlayProvider = StateProvider<bool>((ref) => false);

// Provide the game service via Riverpod.
final gameServiceProvider = Provider((ref) => GameService());

// OTHER
final didUserMoveCardProvider = StateProvider<bool>((ref) => false);

final isPlayersTurnComputedProvider = Provider<bool>((ref) {
  final turnAsync = ref.watch(turnPlayerProvider);
  final playerPosition = ref.watch(playerPositionProvider);
  return turnAsync.when(
    data: (event) {
      final currentTurn = event.snapshot.value as int;
      return currentTurn == playerPosition;
    },
    error: (_, __) => false,
    loading: () => false,
  );
});

// Next game
final nextGameStartProvider = StreamProvider<int>((ref) {
  final nextGameStartRef = FirebaseDatabase.instance.ref('tables/1/nextGameStart');
  return nextGameStartRef.onValue.map((event) {
    final val = event.snapshot.value;
    if (val is int) {
      return val;
    } else if (val is String) {
      return int.tryParse(val) ?? 0;
    }
    return 0;
  });
});
