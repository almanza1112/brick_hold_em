import 'package:brick_hold_em/game/card_key.dart';
import 'package:brick_hold_em/game/card_rules.dart';
import 'package:brick_hold_em/providers/face_up_card_notifier.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:brick_hold_em/providers/hand_notifier.dart';
import 'package:brick_hold_em/providers/tapped_cards_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:brick_hold_em/globals.dart' as globals;

/// ------------------------
/// Game Service
/// ------------------------
/// This class encapsulates API calls and Firebase operations.
/// You can add more methods as needed.
class GameService {
  final DatabaseReference deckRef =
      FirebaseDatabase.instance.ref('tables/1/cards/dealer/deck');
  final DatabaseReference playersCardsRef =
      FirebaseDatabase.instance.ref('tables/1/cards/playerCards');
  final DatabaseReference potRef =
      FirebaseDatabase.instance.ref('tables/1/pot');

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> addCard(String uid, WidgetRef ref) async {
    try {
      final tableRef = FirebaseDatabase.instance.ref('tables/1');

      // 1) Fetch the single top card (key + name)
      final topCardSnapshot = await deckRef.orderByKey().limitToLast(1).once();
      final deckMap = topCardSnapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (deckMap == null || deckMap.isEmpty) {
        // TODO: Handle empty deck case
        // I have a listener in the backend that will reshuffle the deck but do I need
        // anything else here?
        print("Deck is empty—no card to draw.");
        return;
      }
      final String cardKey = deckMap.keys.first as String;
      final String cardName = deckMap[cardKey] as String;

      // 2) Reserve a new push-key for the player's hand
      final newHandRef = playersCardsRef.child(uid).child('hand').push();
      final String newHandKey = newHandRef.key!;

      // 3) Build a multi-location update:
      //    - Remove the deck child at `cards/dealer/deck/$cardKey`
      //    - Add the card under `cards/playerCards/$uid/hand/$newHandKey`
      final updates = <String, dynamic>{
        'cards/dealer/deck/$cardKey': null,
        'cards/playerCards/$uid/hand/$newHandKey': cardName,
      };

      // 4) Apply in one atomic call
      await tableRef.update(updates);

      // 5) Locally sync your Riverpod hand state
      final newCard = CardKey(
        position: ref.read(handProvider).length,
        cardName: cardName,
        isBrick: (cardName == 'brick'),
      );
      ref.read(handProvider.notifier).addCard(newCard);
    } catch (e) {
      print("Error in addCard: $e");
    }
  }

  Future<void> sendPlay(Map<String, dynamic> body) async {
    http.Response response = await http.post(
      Uri.parse("${globals.END_POINT}/table/playCards"),
      body: body,
    );
    if (response.statusCode == 201) {
      // Handle success (e.g., reset state or notify UI)
      print("Play sent successfully");
    } else {
      // Handle error
    }
  }

  Future<void> passPlay() async {
    http.Response response =
        await http.get(Uri.parse("${globals.END_POINT}/table/passturn"));
    if (response.statusCode != 200) {
      // Handle error
    }
  }

  Future<void> foldHand(String uid) async {
    var body = {'uid': uid, 'position': 'YOUR_PLAYER_POSITION_HERE'};
    http.Response response = await http.post(
      Uri.parse('${globals.END_POINT}/table/foldhand'),
      body: body,
    );
    if (response.statusCode != 201) {
      // Handle error folding hand
    }
  }

  Future<void> skipPlayerTurn() async {
    http.Response response =
        await http.get(Uri.parse("${globals.END_POINT}/table/skipturn"));
    if (response.statusCode != 200) {
      // Handle error
    }
  }

  void play(WidgetRef ref, BuildContext context) async {
    final tappedNotifier = ref.read(tappedCardsProvider.notifier);
    final playBtnNotifier = ref.read(isPlayButtonSelectedProvider.notifier);

    // Read the cached face‑up card (a String) from the new notifier.
    final faceUpCard = ref.read(faceUpCardCacheProvider);
    if (faceUpCard.isEmpty) {
      print("Face-up card not available.");
      return;
    }

    // Get tapped cards (as CardKey objects) from tappedCardsProvider.
    final tappedCards = ref.read(tappedCardsProvider);
    // Build a list of tapped card names.
    List<String> cardsBeingPlayed =
        tappedCards.map((card) => card.cardName ?? "").toList();

    // Create the final list by putting the face‑up card first.
    List<String> totalCardsBeingPlayed = [faceUpCard, ...cardsBeingPlayed];

    // Validate the play using CardRules.
    final cardRules = CardRules(cards: totalCardsBeingPlayed);
    var cardRulesResult = cardRules.play();

    if (cardRulesResult['success']) {
      // Set the play animation flag.
      playBtnNotifier.state = true;

      // Get the current hand (as CardKey objects) and build a list of card names.
      final hand = ref.read(handProvider);
      List<String> cardsInHand =
          hand.map((card) => card.cardName ?? "").toList();

      // Get the ante multiplier from the result.
      int anteMultiplier = cardRulesResult['anteMultiplier'];
      String combo = cardRulesResult['combo'];
      String action = cardRulesResult['action'];
      int cardsToDraw = cardRulesResult['cardsToDraw'];

      final String username =
          await secureStorage.read(key: globals.FSS_USERNAME) ?? "Unknown User";

      // Build the POST body.
      var body = {
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'username': username,
        'move': totalCardsBeingPlayed.toString(),
        'cardsToDiscard': cardsBeingPlayed.toString(),
        'cardsInHand': cardsInHand.toString(),
        'position': ref.read(playerPositionProvider).toString(),
        'anteMultiplier': anteMultiplier.toString(),
        'combo': combo.toString(),
        'action': action.toString(),
        'cardsToDraw': cardsToDraw.toString(),
      };

      // If betting is required, add bet info.
      if (ref.read(doYouNeedToCallProvider)) {
      } else {
        await ref.read(gameServiceProvider).sendPlay(body);
      }

      // Clear tapped cards after a successful play.
      tappedNotifier.clear();

      // Reset the play button flag after a short delay.
      Future.delayed(const Duration(milliseconds: 500), () {
        playBtnNotifier.state = false;
      });
    } else {
      // If the play is invalid, indicate it (e.g., set an invalid play flag and vibrate).
      HapticFeedback.heavyImpact();
      HapticFeedback.heavyImpact();
    }
  }
}
