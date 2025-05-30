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
      FirebaseDatabase.instance.ref('tables/1/betting/pot');

  Future<void> addCard(String uid, WidgetRef ref) async {
    try {
      // Fetch the current deck and player's hand from Firebase.
      final deckEvent = await deckRef.once();
      final playersCardsEvent =
          await playersCardsRef.child(uid).child('hand').once();

      // Convert to List<String>
      var deck = List<String>.from(deckEvent.snapshot.value as List);
      var playersCards =
          List<String>.from(playersCardsEvent.snapshot.value as List);

      // Draw the last card from the deck.
      var cardBeingAdded = deck.last;
      // Add it to the player's hand.
      playersCards.add(cardBeingAdded);
      // Remove it from the deck.
      deck.removeLast();

      // Update Firebase.
      await deckRef.set(deck);
      await playersCardsRef.child(uid).child('hand').set(playersCards);

      // Create a new CardKey for the drawn card.
      bool isBrick = cardBeingAdded == 'brick';
      final newCard = CardKey(
          position: ref.read(handProvider).length,
          cardName: cardBeingAdded,
          isBrick: isBrick);

      // Update the local hand by adding the new card.
      ref.read(handProvider.notifier).addCard(newCard);

      // Optionally trigger any chip animations here.
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

  void play(WidgetRef ref, BuildContext context) async {
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
    var result = cardRules.play();

    if (result['success']) {
      // Set the play animation flag.
      ref.read(isPlayButtonSelectedProvider.notifier).state = true;

      // Get the current hand (as CardKey objects) and build a list of card names.
      final hand = ref.read(handProvider);
      List<String> cardsInHand =
          hand.map((card) => card.cardName ?? "").toList();
      
      // Get the ante multiplier from the result.
      int anteMultiplier = result['anteMultiplier'];


      // Build the POST body.
      var body = {
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'move': totalCardsBeingPlayed.toString(),
        'cardsToDiscard': cardsBeingPlayed.toString(),
        'cardsInHand': cardsInHand.toString(),
        'position': ref.read(playerPositionProvider).toString(),
        'anteMultiplier': anteMultiplier.toString(),
      };

      // If betting is required, add bet info.
      if (ref.read(doYouNeedToCallProvider)) {
      } else {
        await ref.read(gameServiceProvider).sendPlay(body);
      }

      // Clear tapped cards after a successful play.
      ref.read(tappedCardsProvider.notifier).clear();
      // Reset the play button flag after a short delay.
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(isPlayButtonSelectedProvider.notifier).state = false;
      });
    } else {
      // If the play is invalid, indicate it (e.g., set an invalid play flag and vibrate).
      ref.read(isThereAnInvalidPlayProvider.notifier).state = true;
      HapticFeedback.heavyImpact();
      HapticFeedback.heavyImpact();
    }
  }
}
