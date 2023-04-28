import 'dart:async';

import 'package:brick_hold_em/game/game_players.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'game_sidemenu.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  final onceRef = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late String faceUpCardName;
  Matrix4 playersCardsTransform = Matrix4.translationValues(0, 0, 0);

  late Future<List<String>> _cardsSnapshot;

  @override
  void initState() {
    _cardsSnapshot = cardsSnapshot();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        //fit: StackFit.expand,
        children: [
          GamePlayers(game: null),
          GameSideMenu(),
          playerCards(),
          deck(),
          faceUpCard(),
          buttons()
        ],
      ),
    );
  }

  double cardWidth = 50;
  double cardHeight = 70;
  var cardWidgets = <Widget>[];

  Widget playerCards() {
    return SafeArea(
      child: Stack(children: [
        Positioned(
          right: 0,
          bottom: 50,
          left: 0,
          child: FutureBuilder(
              future: _cardsSnapshot,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  var cardsList = List<String>.from(snapshot.data as List);

                  // Not having the line below was causing an infinite loop
                  // cardWidgets has to be cleared 
                  cardWidgets.clear();

                  for (var cards in cardsList) {
                    cardWidgets.add(card(cards, "hi"));
                  }
                    print("ob");
                  return Container(
                    height: 70,
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: cardsList.length,
                        itemBuilder: (context, index) {
                          return cardWidgets[index];
                        },
                      ),
                    ),
                  );
                } else {
                  return const Text(
                      "Something went wrong. Unable to retrieve cards.");
                }
              })),
        ),
      ]),
    );
  }



  Matrix4 testMatrix = Matrix4.translationValues(0, 0, 0);
  void moveBox() {
    setState(() {
      testMatrix = Matrix4.translationValues(100, -100, 0);
    });
  }

  Widget card(var card, String index) {
    return AnimatedContainer(
      key: Key(index),
      //color: Colors.black,
      //alignment: Alignment(100, 0),
      transform: playersCardsTransform,
      width: cardWidth,
      height: cardHeight,
      duration: const Duration(seconds: 1),
      child: GestureDetector(
        onTap: () {
          _moveCard();
        },
        child: Image.asset(
          "assets/images/$card.png",
          fit: BoxFit.cover,
          width: cardWidth,
          height: cardHeight,
        ),
      ),
    );
  }

  _moveCard() {
    setState(() {
      playersCardsTransform = Matrix4.translationValues(0, -100, 0);
    });
  }

  Future<List<String>> cardsSnapshot() async {
    final snapshot =
        await onceRef.child('tables/1/cards/$uid/startingHand').get();
    if (snapshot.exists) {
      var cardsList = List<String>.from(snapshot.value as List);
      return cardsList;
    } else {
      return [];
    }
  }

  Widget deck() {
    return Center(
        child: Image.asset(
      "assets/images/backside.png",
      fit: BoxFit.cover,
      width: cardWidth,
      height: cardHeight,
    ));
  }

  Widget faceUpCard() {
    return SafeArea(child: LayoutBuilder(
        builder: ((BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          Positioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left:
                  (constraints.constrainWidth() / 2) - ((cardWidth * 2.5) + 10),
              child: FutureBuilder(
                future: getFaceUpCard(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    faceUpCardName = snapshot.data.toString();
                    return Image.asset(
                      "assets/images/$faceUpCardName.png",
                      width: cardWidth,
                      height: cardHeight,
                    );
                  } else {
                    return Text(
                        "An error occcured retrieving the face up card");
                  }
                },
              ))
        ],
      );
    })));
  }

  getFaceUpCard() async {
    DatabaseReference faceUpCardRef =
        FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');
    Completer<String> completer = Completer();

    faceUpCardRef.onValue.listen((event) async {
      var faceUpCardList = List<String>.from(event.snapshot.value as List);
      //faceUpCardList = _faceUpCardList;
      setState(() {
        faceUpCardName = faceUpCardList[0];
      });
      completer.complete(faceUpCardList[0]);
    }).onError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Widget buttons() {
    return SafeArea(
      child: Stack(
        children: [
          Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Image.asset("assets/images/plus_one.png"),
                onPressed: () {
                  addCard();
                },
              ))
        ],
      ),
    );
  }

  addCard() async {
    final dealerRef = FirebaseDatabase.instance.ref('tables/1/cards/dealer');
    final playersCardsRef =
        FirebaseDatabase.instance.ref('tables/1/cards/$uid/startingHand');
    final cardsRef = FirebaseDatabase.instance.ref('tables/1/cards');
    final event = await dealerRef.once();
    final playerEvent = await playersCardsRef.once();

    var deck = List<String>.from(event.snapshot.value as List);
    var playersCards = List<String>.from(playerEvent.snapshot.value as List);

    var cardBeingAdded = deck[deck.length - 1];
    playersCards.add(cardBeingAdded);
    deck.removeLast();

    await cardsRef.update({"dealer": deck, "$uid/startingHand": playersCards});

    setState(() {
      //cardWidgets.add(card(cardBeingAdded));
    });
  }
}
