import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:brick_hold_em/game/game_players.dart';

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
  Matrix4 playersCardsTransform = Matrix4.translationValues(0, 0, 2);

  late Future<List<String>> _cardsSnapshot;
  late Future<String> _getFaceUpCard;

  double cardWidth = 50;
  double cardHeight = 70;
  //var cardWidgets = <Widget>[];
  var cardWidgetsBuilderList = <Widget>[];

  bool isStateChanged = false;

  @override
  void initState() {
    _cardsSnapshot = cardsSnapshot();
    _getFaceUpCard = getFaceUpCard();
    addUserToTable();
    super.initState();
  }

  addUserToTable() async {
    DatabaseReference database = FirebaseDatabase.instance.ref('tables/1');

    await database.update({
      "players/$uid/name": FirebaseAuth.instance.currentUser!.displayName,
      "players/$uid/photoURL": FirebaseAuth.instance.currentUser!.photoURL
    }).then((value) {
      print("much success");
    }).onError((error, stackTrace) {
      print("I am a failure");
    });
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

  Widget playerCards() {
    return SafeArea(
      child: Stack(children: [
        Positioned(
          right: 0,
          bottom: 50,
          left: 0,
          child: FutureBuilder<List<String>>(
              future: _cardsSnapshot,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  var cardsList = List<String>.from(snapshot.data as List);

                  // Not having the line below was causing an infinite loop
                  // cardWidgets has to be cleared
                  var cardWidgets = <Widget>[];
                  //cardWidgets.clear(); //uncomment this line if you are declaring cardWidgets globally

                  for (int i = 0; i < cardsList.length; i++) {
                    CardKey cardKey = CardKey(
                        position: i,
                        cardName: cardsList[i],
                        cardXY: playersCardsTransform);
                    cardWidgets.add(card(cardKey));
                  }

                  if (!isStateChanged) {
                    cardWidgetsBuilderList = cardWidgets;
                  }

                  print("infinite loop check");
                
                  return SizedBox(
                    height: 70,
                    child: Center(
                      child: ListView.builder(
                        clipBehavior: Clip.none,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: cardWidgetsBuilderList.length,
                        itemBuilder: (context, index) {
                          return cardWidgetsBuilderList[index];
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

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget card(CardKey cardKey) {
    String cardName = cardKey.cardName!;
    return AnimatedContainer(
      key: ValueKey(cardKey),
      transform: Matrix4.translationValues(0, 0, 0),
      width: cardWidth,
      height: cardHeight,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          setState(() {
            cardKey.cardXY = Matrix4.translationValues(0, -200, 0);
          });
          //print(cardKey.toString());
          //testSet(cardKey.position, cardKey);
          //_moveCard();
        },
        child: Image.asset(
          "assets/images/$cardName.png",
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
                future: _getFaceUpCard,
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

  Future<String> getFaceUpCard() async {
    /**
     // The following code kept throwing Bad State errors
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
     */

    DatabaseReference faceUpCardRef =
        FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');

    try {
      var event = await faceUpCardRef.once();
      var faceUpCardList = List<String>.from(event.snapshot.value as List);
      setState(() {
        faceUpCardName = faceUpCardList[0];
      });
      return faceUpCardList[0];
    } catch (error) {
      throw error;
    }
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
      isStateChanged = true;
      cardWidgetsBuilderList.add(card(CardKey(
          position: cardWidgetsBuilderList.length,
          cardName: cardBeingAdded,
          cardXY: playersCardsTransform)));
    });
  }
}

class CardKey {
  int? position;
  String? cardName;
  Matrix4? cardXY;

  CardKey(
      {required this.position, required this.cardName, required this.cardXY});

  CardKey copyWith({int? position, String? cardName, Matrix4? cardXY}) {
    return CardKey(
        position: position ?? this.position,
        cardName: cardName ?? this.cardName,
        cardXY: cardXY ?? this.cardXY);
  }

  @override
  String toString() =>
      'CardKeys(position: $position, cardName: $cardName, cardXY: $cardXY)';
}
