import 'dart:async';
import 'dart:convert';
import 'package:brick_hold_em/game/game_cards.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:brick_hold_em/game/game_players.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:brick_hold_em/globals.dart' as globals;

import 'card_key.dart';
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
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late String faceUpCardName;
  Matrix4 playersCardsTransform = Matrix4.translationValues(0, 0, 2);

  //List<Widget> tappedCards = <Widget>[];

  double cardWidth = 50;
  double cardHeight = 70;
  //var cardWidgets = <Widget>[];
  late double constrainHeight, constrainWidth;
  //var cardWidgetsBuilderList = <Widget>[];

  bool isYourTurn = false;



  DatabaseReference turnOrderListener =
      FirebaseDatabase.instance.ref('tables/1/turnOrder/turnPlayer');
  DatabaseReference faceUpCardListener =
      FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');
  DatabaseReference deckCountListener =
      FirebaseDatabase.instance.ref('tables/1/cards/dealer/deckCount');

  DatabaseReference database = FirebaseDatabase.instance.ref('tables/1');
  TextStyle turnPlayerTextStyle = const TextStyle(
      color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold);

  final player = AudioPlayer();

  @override
  void initState() {
    addUserToTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Stack(
        //fit: StackFit.expand,
        children: [
          GamePlayers(),
          GameCards(),
          deck(),
          faceUpCard(),
          buttons(),
          GameSideMenu(),
          turnPlayerInfo(),
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // TODO: need to add this to the backend to get info for username or displayname
  addUserToTable() async {
    await database.update({
      "players/$uid": {
        'name' : FirebaseAuth.instance.currentUser!.displayName,
        'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
        'cardCount' : 0,

      }
    }).then((value) {
      // User added
    }).onError((error, stackTrace) {
      // TODO: error game flow
      // Show Dialog that user was not added, error occured
    });
  }

  Widget turnPlayerInfo() {
    int countdown = 30;

    return SafeArea(
      child: Stack(children: [
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: StreamBuilder(
                stream: turnOrderListener.onValue,
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("There was an error getting turn info");
                  }

                  if (snapshot.hasData) {
                    var turnPlayerUid =
                        (snapshot.data!).snapshot.value as String;
                    if (turnPlayerUid == uid) {
                      //setIsYourTurn(true);
                      return StatefulBuilder(builder: (context, setState) {
                        // Sound for the countdown
                        SystemSound.play(SystemSoundType.click);
                        // Vibration for the countdown
                        HapticFeedback.mediumImpact();

                        if (countdown > 0) {
                          Timer(Duration(seconds: 1), () {
                            setState(() {
                              countdown--;
                            });
                          });
                        } else {
                          ranOutOfTime();
                        }

                        return Column(
                          children: [
                            Text(
                              "IT'S YOUR TURN",
                              style: turnPlayerTextStyle,
                            ),
                            Text(
                              "$countdown",
                              style: turnPlayerTextStyle,
                            )
                          ],
                        );
                      });
                    } else {
                      return Text(
                        "Waiting...",
                        style: turnPlayerTextStyle,
                      );
                    }
                  } else {
                    return const Text("Snapshot has no data!");
                  }
                })),
          ),
        ),
      ]),
    );
  }

  void setIsYourTurn(bool yourTurn) {
    setState(() {
      isYourTurn = yourTurn;
    });
  }


  Widget deck() {
    return Center(
        child: GestureDetector(
            onTap: () {
              addCard();
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              color: Colors.blueAccent,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/backside.png",
                    fit: BoxFit.cover,
                    width: cardWidth,
                    height: cardHeight,
                  ),
                  Center(
                    child: StreamBuilder(
                        stream: deckCountListener.onValue,
                        builder: ((context, snapshot) {
                          if (snapshot.hasError) {
                            return CircularProgressIndicator();
                          }

                          if (snapshot.hasData) {
                            int count = (snapshot.data!).snapshot.value as int;

                            return Text(
                              "$count",
                              style: const TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            );
                          } else {
                            return Text("n");
                          }
                        })),
                  )
                ],
              ),
            )));
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
              child: StreamBuilder(
                stream: faceUpCardListener.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error gettign card");
                  }

                  if (snapshot.hasData) {
                    String faceUpCard =
                        (snapshot.data!).snapshot.value as String;
                    print("faceUpCards: $faceUpCard");
                    return Image.asset(
                      "assets/images/$faceUpCard.png",
                      width: cardWidth,
                      height: cardHeight,
                    );
                  } else {
                    return const Text("game has not started");
                  }
                },
              ))
        ],
      );
    })));
  }

  Widget buttons() {
    return Visibility(
      //visible: isYourTurn,
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () {
                    playButton();
                  },
                  child: Text("Play")),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: () {
                  passPlay();
                },
                child: Text("pass"),
              ),
            )
          ],
        ),
      ),
    );
  }

  playButton() async {
    // setState(() {
    //   playButtonSelected = true;
    // });
    // List<String> cardsBeingPlayed = <String>[];
    // for (int i = 0; i < tappedCards.length; i++) {
    //   ValueKey<CardKey> t = tappedCards[i].key! as ValueKey<CardKey>;
    //   cardsBeingPlayed.add(t.value.cardName!);
    // }

    // DatabaseReference dbMoves = FirebaseDatabase.instance.ref('tables/1/moves');
    // DatabaseReference newMoves = dbMoves.push();
    // await newMoves.set({uid: cardsBeingPlayed}).then((value) {
    //   setFaceUpCardAndHand(cardsBeingPlayed.last);
    //   passPlay();
    // });
  }

  setFaceUpCardAndHand(String card) async {
    // There is at least one card
    // if (cardWidgetsBuilderList.length > 0) {
    //   List<String> cardsInHand = <String>[];
    //   for (int i = 0; i < cardWidgetsBuilderList.length; i++) {
    //     ValueKey<CardKey> t =
    //         cardWidgetsBuilderList[i].key! as ValueKey<CardKey>;
    //     cardsInHand.add(t.value.cardName!);
    //   }

    //   DatabaseReference faceUpCardRef =
    //       FirebaseDatabase.instance.ref('tables/1/cards');

    //   await faceUpCardRef.update(
    //       {'faceUpCard': card, 'playerCards/$uid/startingHand': cardsInHand}).then((value) {
    //     Future.delayed(const Duration(milliseconds: 500), () {
    //       setState(() {
    //         playButtonSelected = false;
    //         tappedCards.clear();
    //       });
    //     });
    //   });
    // } else {
    //   // No cards left, you are the winner

    // }
  }

  passPlay() async {
    http.Response response =
        await http.get(Uri.parse("${globals.END_POINT}/table/passturn"));

    Map data = jsonDecode(response.body);
    print("HEREEEE");
    print(data);
  }

  addCard() async {
    // Why call the players starting hand again? To avoid confusion in case
    // player has any cards that are tapped and on the table/ Can this be optimized?
    // Maybe..
    // TODO: look into this, not a priority

    Source cardDrawnSound = AssetSource("sounds/card_drawn.mp3");
    player.play(cardDrawnSound);
    final dealerRef =
        FirebaseDatabase.instance.ref('tables/1/cards/dealer/deck');
    final playersCardsRef =
        FirebaseDatabase.instance.ref('tables/1/cards/playerCards/$uid/startingHand');
    final cardsRef = FirebaseDatabase.instance.ref('tables/1/cards');
    final event = await dealerRef.once();
    final playerEvent = await playersCardsRef.once();

    var deck = List<String>.from(event.snapshot.value as List);
    var playersCards = List<String>.from(playerEvent.snapshot.value as List);

    var cardBeingAdded = deck[deck.length - 1];
    playersCards.add(cardBeingAdded);
    deck.removeLast();

    await cardsRef
        .update({"dealer/deck": deck, "playerCards/$uid/startingHand": playersCards});

    // TODO: only disablinf for now
    // setState(() {
    //   isStateChanged = true;
    //   cardWidgetsBuilderList.add(card(CardKey(
    //       position: cardWidgetsBuilderList.length,
    //       cardName: cardBeingAdded,
    //       cardXY: playersCardsTransform)));
    // });
  }

  ranOutOfTime() async {
    await addCard();
    await passPlay();
  }
}
