import 'package:brick_hold_em/game/server_linear_progress_indicator_turn.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

/// UnifiedTurnTimer shows a circular progress indicator if it is your turn.
/// Otherwise, it shows either:
///   • “Player N to call and draw M” (if someone is mid-ante)
///   • or a generic “WAITING…” fallback
class GameTurnTimer extends ConsumerWidget {
  const GameTurnTimer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) Watch the turn-player stream
    final turnAsync = ref.watch(turnPlayerProvider);
    // 2) Watch the ante-to-call stream
    final anteAsync = ref.watch(anteToCallProvider);
    // 3) Read your own “seat” or “position” so we know if it’s your turn/ante
    final int myPosition = ref.watch(playerPositionProvider);

    // If either is still loading, show a single spinner:
    if (turnAsync is AsyncLoading || anteAsync is AsyncLoading) {
      return const Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // If turnPlayerProvider errored:
    if (turnAsync is AsyncError) {
      return Center(child: Text("Error (turn): ${turnAsync.error}"));
    }

    // If anteToCallProvider errored:
    if (anteAsync is AsyncError) {
      return Center(child: Text("Error (ante): ${anteAsync.error}"));
    }

    // At this point, both streams have data:
    final DatabaseEvent turnEvent = (turnAsync as AsyncData).value;
    final DatabaseEvent anteEvent = (anteAsync as AsyncData).value;

    // Extract “who’s turn” (assuming you stored an int in the DB)
    final int currentTurn = turnEvent.snapshot.value as int;
    // Extract “who must ante next” and “how many cards to draw” from the DB.
    // For this example, let’s assume anteEvent.snapshot.value is a Map:
    //   { "playerPos": 2, "drawCount": 2 }
    // (adjust this cast to match your actual schema)
    final rawAnte = anteEvent.snapshot.value;
    int? playerToCallPosition;
    int? amountToCall;
    String? nextTurnPlayerUsername;
    int? cardsToDraw; // Default to 2 cards to draw

    if (rawAnte is Map<Object?, Object?>) {
      // If you wrote this in your Realtime DB:
      //   tables/1/anteToCall: { "playerPos": 2, "drawCount": 2 }
      playerToCallPosition = (rawAnte['playerToCallPosition'] as int?) ;
      amountToCall = (rawAnte['amountToCall'] as int?) ;
      nextTurnPlayerUsername = (rawAnte['nextTurnPlayerUsername'] as String?);
      cardsToDraw = (rawAnte['cardsToDraw'] as int?);
    }

    // 1) If it’s your turn, show the timer:
    if (currentTurn == myPosition) {
      return const ServerLinearProgressIndicatorTurn();
    }

    // 2) Otherwise, if someone needs to ante right now, show a descriptive message:
    if (playerToCallPosition != null && amountToCall != null) {
      // If *you* are the one who needs to ante, you could show a different UI,
      // but since it’s “not your turn,” we assume someone else is anteing.
      if (playerToCallPosition == myPosition) {
        // (Optional) If you actually want to tell *yourself* “You must pay…”
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 40,
            color: Colors.redAccent,
            child: Center(
              child: Text(
                "YOU need to call and draw $amountToCall",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      } else {
        // Another player is mid-ante:
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 40,
            color: Colors.grey.shade800,
            child: Center(
              child: Text(
                "$nextTurnPlayerUsername to pay $amountToCall and draw $cardsToDraw",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }
    }

    // 3) If no one is currently anteing (or DB is null), fall back to a generic WAITING:
    return const Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 40,
        child: ColoredBox(
          color: Colors.grey,
          child: Center(
            child: Text(
              "WAITING…",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}