import 'package:brick_hold_em/game/new/services/game_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/players/player.dart';

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

enum BottomState { needToCall, myTurn, waiting }

final bottomStateProvider = Provider<BottomState>((ref) {
  final turnAsync = ref.watch(turnPlayerProvider);
  final anteAsync = ref.watch(anteToCallProvider);
  final myPos     = ref.read(playerPositionProvider);

  // If any stream is still loading, treat it as “waiting”
  if (turnAsync is AsyncLoading || anteAsync is AsyncLoading) {
    return BottomState.waiting;
  }

  // On error, also “waiting”
  if (turnAsync is AsyncError || anteAsync is AsyncError) {
    return BottomState.waiting;
  }

  // Both have data:
  final currentTurn = (turnAsync as AsyncData).value.snapshot.value as int;
  final anteData    = (anteAsync as AsyncData).value.snapshot.value as Map?;
  final needCallPos = anteData?['playerToCallPosition'] as int?  ?? -1;
  final didCall     = anteData?['didPlayerCall']      as bool? ?? true;

  if (needCallPos == myPos && !didCall) {
    return BottomState.needToCall;
  }
  if (currentTurn == myPos) {
    return BottomState.myTurn;
  }
  return BottomState.waiting;
});

// TODO: need to check if this is the best way to handle invalid plays animation
final isThereAnInvalidPlayProvider = StateProvider<bool>((ref) => false);

final anteToCallProvider = StreamProvider<DatabaseEvent>((ref) {
  return FirebaseDatabase.instance
      .ref('tables/1/anteToCall')
      .onValue;
});

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

// User's Chips
final chipCountStreamProvider = StreamProvider<int>((ref) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseDatabase.instance
      .ref('tables/1/chips/$uid/chipCount')
      .onValue
      .map((event) {
    if (event.snapshot.value != null) {
      return int.tryParse(event.snapshot.value.toString()) ?? 0;
    }
    return 0;
  });
});
