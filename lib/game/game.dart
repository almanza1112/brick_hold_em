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

extension GlobalPaintBounds on BuildContext {
  Rect? get globalPaintBounds {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
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
  late double constrainHeight, constrainWidth;
  var cardWidgetsBuilderList = <Widget>[];

  bool isStateChanged = false;

  Duration tableCardAnimationDuration = const Duration(milliseconds: 500);
  bool playButtonSelected = false;

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
          playerCards(),
          deck(),
          fiveCardBorders(),
          faceUpCard(),
          buttons(),
          GameSideMenu(),
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

  List<Widget> tappedCards = <Widget>[];
  Widget card(CardKey cardKey) {
    String cardName = cardKey.cardName!;
    var _cardKey = ValueKey(cardKey);

    return AnimatedContainer(
      key: _cardKey,
      transform: playersCardsTransform,
      width: cardWidth,
      height: cardHeight,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      child: GestureDetector(
        onTap: () {
          if (tappedCards.length < 4) {
            var result = cardWidgetsBuilderList
                .indexWhere((element) => element.key == _cardKey);
            setState(() {
              isStateChanged = true;
              tappedCards.add(cardWidgetsBuilderList[result]);
              cardWidgetsBuilderList
                  .removeWhere((element) => element.key == _cardKey);
            });
          }
          // THIS CODE BELOW IS FOR ANIMATING THE CARDS ONTO THE TABLE
          // ALSO THE ANIMTED CONTAINER HAD STATEFULL BUILDER WRAPPED AROUND IT!!!
          //print("before: ${context.globalPaintBounds}");
          // 170 because of the 50 bottom paddding (from Positioned of playerCards) and
          // 50 for faceUpcard, and 70 for cardHeight
          // double y = -(constrainHeight / 2) + 170;
          // double x = 100;
          // setState(() {
          //
          //   playersCardsTransform = Matrix4.translationValues(x, y, 0);
          // });
          // print("after: ${context.globalPaintBounds}");

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

  Widget fiveCardBorders() {
    return SafeArea(child: LayoutBuilder(
        builder: ((BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          // Red dot posiition 1
          Positioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left:
                  (constraints.constrainWidth() / 2) - ((cardWidth * 2.5) + 10),
              child: const SizedBox(
                  height: 70,
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.circle_sharp,
                      color: Colors.red,
                      size: 12,
                    ),
                  ))),
          
          // Red dot posiition 2
          Positioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left:
                  (constraints.constrainWidth() / 2) - ((cardWidth * 1.5) + 5),
              child: const SizedBox(
                  height: 70,
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.circle_sharp,
                      color: Colors.red,
                      size: 12,
                    ),
                  ))),
          
          // Red dot posiition 3
          Positioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: (constraints.constrainWidth() / 2) - (cardWidth / 2),
              child: const SizedBox(
                  height: 70,
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.circle_sharp,
                      color: Colors.red,
                      size: 12,
                    ),
                  ))),
          
          // Red dot posiition 4
          Positioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: (constraints.constrainWidth() / 2) + ((cardWidth / 2) + 5),
              child: const SizedBox(
                  height: 70,
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.circle_sharp,
                      color: Colors.red,
                      size: 12,
                    ),
                  ))),
          
          // Red dot posiition 5
          Positioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left:
                  (constraints.constrainWidth() / 2) + ((cardWidth * 1.5) + 10),
              child: const SizedBox(
                  height: 70,
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.circle_sharp,
                      color: Colors.red,
                      size: 12,
                    ),
                  ))),

          // Card position #1 (faceUpCard)
          Positioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left:
                  (constraints.constrainWidth() / 2) - ((cardWidth * 2.5) + 10),
              child: Container(
                height: 70,
                width: 50,
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.yellowAccent)),
              )),

          // Card position #2
          AnimatedPositioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: playButtonSelected
                  ? (constraints.constrainWidth() / 2) -
                      ((cardWidth * 2.5) + 10)
                  : (constraints.constrainWidth() / 2) -
                      ((cardWidth * 1.5) + 5),
              duration: tableCardAnimationDuration,
              child: Container(
                //margin: const EdgeInsets.all(15.0),
                height: 70,
                width: 50,
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.yellowAccent)),
                child: tableCard(0),
              )),

          // Card position #3
          AnimatedPositioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: playButtonSelected
                  ? (constraints.constrainWidth() / 2) -
                      ((cardWidth * 2.5) + 10)
                  : (constraints.constrainWidth() / 2) - (cardWidth / 2),
              duration: tableCardAnimationDuration,
              child: Container(
                //margin: const EdgeInsets.all(15.0),
                height: 70,
                width: 50,
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.yellowAccent)),
                child: tableCard(1),
              )),

          // Card position #4
          AnimatedPositioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: playButtonSelected
                  ? (constraints.constrainWidth() / 2) -
                      ((cardWidth * 2.5) + 10)
                  : (constraints.constrainWidth() / 2) + ((cardWidth / 2) + 5),
              duration: tableCardAnimationDuration,
              child: Container(
                //margin: const EdgeInsets.all(15.0),
                height: 70,
                width: 50,
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.yellowAccent)),
                child: tableCard(2),
              )),

          //Card position #5
          AnimatedPositioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: playButtonSelected
                  ? (constraints.constrainWidth() / 2) -
                      ((cardWidth * 2.5) + 10)
                  : (constraints.constrainWidth() / 2) +
                      ((cardWidth * 1.5) + 10),
              duration: tableCardAnimationDuration,
              child: Container(
                //margin: const EdgeInsets.all(15.0),
                height: 70,
                width: 50,
                //decoration: BoxDecoration(
                //border: Border.all(color: Colors.yellowAccent)),
                child: tableCard(3),
              )),
        ],
      );
    })));
  }

  Widget? tableCard(int pos) {
    if (tappedCards.asMap().containsKey(pos)) {
      return Stack(
        children: [
          tappedCards[pos],
          GestureDetector(
            onTap: () {
              setState(() {
                cardWidgetsBuilderList.add(tappedCards[pos]);
                tappedCards.removeAt(pos);
              });
            },
          )
        ],
      );
    } else {
      return null;
    }
  }

  Widget faceUpCard() {
    return SafeArea(child: LayoutBuilder(
        builder: ((BuildContext context, BoxConstraints constraints) {
      constrainWidth = constraints.constrainWidth();
      constrainHeight = constraints.constrainHeight();
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
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    playButtonSelected = true;
                  });
                },
                child: Text("Play")),
          )
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
