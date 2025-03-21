import 'package:firebase_database/firebase_database.dart';
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

  Future<void> addCard(String uid) async {
    // Example: get the deck and player's hand, remove last card from deck,
    // add it to player's hand, update chip count and pot, etc.
    final deckEvent = await deckRef.once();
    final playersCardsEvent =
        await playersCardsRef.child(uid).child('hand').once();

    var deck = List<String>.from(deckEvent.snapshot.value as List);
    var playersCards =
        List<String>.from(playersCardsEvent.snapshot.value as List);

    var cardBeingAdded = deck.last;
    playersCards.add(cardBeingAdded);
    deck.removeLast();

    // Here you would add logic to update chip counts and trigger animations.
    await deckRef.update({"": deck}); // update deck
    await playersCardsRef.child(uid).child('hand').set(playersCards);
    // Also update pot or chip counts as needed.
  }

  Future<void> sendPlay(Map<String, dynamic> body) async {
    http.Response response = await http.post(
      Uri.parse("${globals.END_POINT}/table/playCards"),
      body: body,
    );
    if (response.statusCode == 201) {
      // Handle success (e.g., reset state or notify UI)
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
}