import 'package:brick_hold_em/game/card_rules.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:brick_hold_em/globals.dart' as globals;
import 'card_key.dart';
import '../providers/game_providers.dart';

class GameCards extends ConsumerStatefulWidget {
  const GameCards({super.key});

  @override
  GameCardsPageState createState() => GameCardsPageState();
}

class GameCardsPageState extends ConsumerState<GameCards> {
  late Future<List<String>> _cardsSnapshot;
  final onceRef = FirebaseDatabase.instance.ref();
  bool isStateChanged = false;
  var cardWidgetsBuilderList = <Widget>[];
  double handCardWidth = 50;
  double handCardHeight = 70;
  double tableCardWidth = 40;
  double tableCardHeight = 56;

  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<Widget> tappedCards = <Widget>[];

  final player = AudioPlayer();

  Duration tableCardAnimationDuration = const Duration(milliseconds: 250);

  late double constrainHeight, constrainWidth;

  DatabaseReference faceUpCardListener =
      FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');

  DatabaseReference deckCountListener =
      FirebaseDatabase.instance.ref('tables/1/cards/dealer/deckCount');

  DatabaseReference movesRef = FirebaseDatabase.instance.ref('tables/1/moves');

  late DatabaseReference playerCardCount;

  // DatabaseReference cardsInHandListener = FirebaseDatabase.instance
  //     .ref('tables/1/cards/playerCards/32Zp41SqjzStoba7J6Tu2DYmk7E3/hand');

  @override
  void initState() {
    _cardsSnapshot = cardsSnapshot();
    playerCardCount = FirebaseDatabase.instance.ref('tables/1/cards/playerCards/$uid/hand');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          playerCards(),
          fiveCardBorders(),
          faceUpCard(),
          deck(),
          buttons(),
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
                    CardKey cardKey =
                        CardKey(position: i, cardName: cardsList[i]);
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

  // SO!! this widget below is an attempt to use StreamBuilder, this gets tricky since the stream can
  // override the shuffle effect.
  // TODO: need to look over this in the near f

  /*
   

Widget playerCards() {
    return SafeArea(
      child: Stack(children: [
        Positioned(
          right: 0,
          bottom: 50,
          left: 0,
          child: StreamBuilder(
              stream: cardsInHandListener.onValue,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  List cardsList = [];
                  print(snapshot.data!.snapshot.children.length);
                  for (final child in snapshot.data!.snapshot.children) {                    
                    cardsList.add(child.value);
                  }

                  var cardWidgets = <Widget>[];
                  //cardWidgets.clear(); //uncomment this line if you are declaring cardWidgets globally

                  for (int i = 0; i < cardsList.length; i++) {
                    CardKey cardKey =
                        CardKey(position: i, cardName: cardsList[i]);
                    cardWidgets.add(card(cardKey));
                  }

                  // I did this without an explanation, code works with this
                  // if statement but have no idea why 
                  if (!isStateChanged) {
                    cardWidgetsBuilderList = cardWidgets;
                  }

                  print("infinite loop check");

                  return SizedBox(
                    height: 70,
                    child: Center(
                      child: ListView.builder(
                        //clipBehavior: Clip.none,
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



   */

  Widget deck() {
    return Center(
        child: GestureDetector(
            onTap: () {
              // Make sure it is players turn and if player has not drawn a card yet
              if (ref.read(didPlayerAddCardThisTurnProvider) == false &&
                  ref.read(isPlayersTurnProvider) == true) {
                addCard();
              }
            },
            child: Container(
              width: tableCardWidth,
              height: tableCardHeight,
              color: Colors.blueAccent,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/backside.png",
                    fit: BoxFit.cover,
                    width: tableCardWidth,
                    height: tableCardHeight,
                  ),
                  Center(
                    child: StreamBuilder(
                        stream: deckCountListener.onValue,
                        builder: ((context, snapshot) {
                          if (snapshot.hasError) {
                            return const CircularProgressIndicator();
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
                            return const Text("n");
                          }
                        })),
                  )
                ],
              ),
            )));
  }

  Widget fiveCardBorders() {
    return SafeArea(child: LayoutBuilder(
        builder: ((BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          // Red dot posiition 1
          Positioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: (constraints.constrainWidth() / 2) -
                  ((tableCardWidth * 2.5) + 10),
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
              left: (constraints.constrainWidth() / 2) -
                  ((tableCardWidth * 1.5) + 5),
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
              left: (constraints.constrainWidth() / 2) - (tableCardWidth / 2),
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
              left: (constraints.constrainWidth() / 2) +
                  ((tableCardWidth / 2) + 5),
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
              left: (constraints.constrainWidth() / 2) +
                  ((tableCardWidth * 1.5) + 10),
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
              left: (constraints.constrainWidth() / 2) -
                  ((tableCardWidth * 2.5) + 10),
              child: Container(
                height: 70,
                width: 50,
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.yellowAccent)),
              )),

          // Card position #2
          AnimatedPositioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: ref.read(isPlayButtonSelectedProvider)
                  ? (constraints.constrainWidth() / 2) -
                      ((tableCardWidth * 2.5) + 10)
                  : (constraints.constrainWidth() / 2) -
                      ((tableCardWidth * 1.5) + 5),
              duration: tableCardAnimationDuration,
              child: Container(
                //margin: const EdgeInsets.all(15.0),
                height: tableCardHeight,
                width: tableCardWidth,
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.yellowAccent)),
                child: tableCard(0),
              )),

          // Card position #3
          AnimatedPositioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: ref.read(isPlayButtonSelectedProvider)
                  ? (constraints.constrainWidth() / 2) -
                      ((tableCardWidth * 2.5) + 10)
                  : (constraints.constrainWidth() / 2) - (tableCardWidth / 2),
              duration: tableCardAnimationDuration,
              child: Container(
                //margin: const EdgeInsets.all(15.0),
                height: tableCardHeight,
                width: tableCardWidth,
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.yellowAccent)),
                child: tableCard(1),
              )),

          // Card position #4
          AnimatedPositioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: ref.read(isPlayButtonSelectedProvider)
                  ? (constraints.constrainWidth() / 2) -
                      ((tableCardWidth * 2.5) + 10)
                  : (constraints.constrainWidth() / 2) +
                      ((tableCardWidth / 2) + 5),
              duration: tableCardAnimationDuration,
              child: Container(
                //margin: const EdgeInsets.all(15.0),
                height: tableCardHeight,
                width: tableCardWidth,
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.yellowAccent)),
                child: tableCard(2),
              )),

          //Card position #5
          AnimatedPositioned(
              top: (constraints.constrainHeight() / 2) + 50,
              left: ref.read(isPlayButtonSelectedProvider)
                  ? (constraints.constrainWidth() / 2) -
                      ((tableCardWidth * 2.5) + 10)
                  : (constraints.constrainWidth() / 2) +
                      ((tableCardWidth * 1.5) + 10),
              duration: tableCardAnimationDuration,
              child: Container(
                //margin: const EdgeInsets.all(15.0),
                height: tableCardHeight,
                width: tableCardWidth,
                //decoration: BoxDecoration(
                //border: Border.all(color: Colors.yellowAccent)),
                child: tableCard(3),
              )),
        ],
      );
    })));
  }

  Future<List<String>> cardsSnapshot() async {
    final snapshot =
        await onceRef.child('tables/1/cards/playerCards/$uid/hand').get();
    if (snapshot.exists) {
      var cardsList = List<String>.from(snapshot.value as List);
      return cardsList;
    } else {
      return [];
    }
  }

  // TODO: Make into its on class for better functionality
  Widget card(CardKey cardKey) {
    String cardName = cardKey.cardName!;
    var _cardKey = ValueKey(cardKey);

    return SizedBox(
      key: _cardKey,
      width: handCardWidth,
      height: handCardHeight,
      child: GestureDetector(
        onTap: () {
          if (ref.read(isPlayersTurnProvider)) {
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
          }
        },
        child: Image.asset(
          "assets/images/$cardName.png",
          fit: BoxFit.cover,
          width: handCardWidth,
          height: handCardHeight,
        ),
      ),
    );
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
              left: (constraints.constrainWidth() / 2) -
                  ((tableCardWidth * 2.5) + 10),
              child: GestureDetector(
                  onTap: getPreviousMove, child: faceUpCardImage()))
        ],
      );
    })));
  }

  Widget faceUpCardImage() {
    final liveFaceUpCard = ref.watch(faceUpCardProvider);

    return liveFaceUpCard.when(
        data: (event) {
          final data = event.snapshot.value.toString();
          return Image.asset(
            "assets/images/$data.png",
            width: tableCardWidth,
            height: tableCardHeight,
          );
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => const CircularProgressIndicator());
  }

  getPreviousMove() async {
    movesRef.limitToLast(1).get().then((snapshot) {
      print(snapshot.value);
    });
  }

  Widget buttons() {
    final liveTurnPlayer = ref.watch(turnPlayerProvider);
    final playerPosition = ref.read(playerPositionProvider);

    const double leftPosition = 10;
    const double rightPosition = 10;

    return liveTurnPlayer.when(
        data: (event) {
          final turnPlayerUid = event.snapshot.value;
          if (turnPlayerUid == playerPosition) {
            return Positioned(
              bottom: 0,
              left: leftPosition,
              right: rightPosition,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: passPlay,
                      child: const Text("Pass"),
                    ),
                    ElevatedButton(
                        onPressed: playButton, child: const Text("Play")),
                    ElevatedButton(
                        onPressed: shuffleHand,
                        child: const Icon(Icons.shuffle))
                  ],
                ),
              ),
            );
          } else {
            return Positioned(
                left: leftPosition,
                right: rightPosition,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: shuffleHand,
                        child: const Icon(Icons.shuffle))
                  ],
                ));
          }
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => const CircularProgressIndicator());
  }

  playButton() async {
    // Get faceUpCard from the StreamProvider = faceUpCardProvider
    final faceUpCardRefOnce = ref.read(faceUpCardProvider);
    final faceUpCardName = faceUpCardRefOnce.asData!.value.snapshot.value;

    // Create empty list for cards that are being played (tapped cards)
    List<String> cardsBeingPlayed = <String>[];

    // Loop through tappCards list to populate cardsBeingPlayed list
    for (int i = 0; i < tappedCards.length; i++) {
      ValueKey<CardKey> t = tappedCards[i].key! as ValueKey<CardKey>;
      cardsBeingPlayed.add(t.value.cardName!);
    }

    // Create list that adds faceUpCard
    List<String> totalCardsBeingPlayed = [
      faceUpCardName.toString(),
      ...cardsBeingPlayed
    ];

    // Make sure list with the faceUpCard(totalCardsBeingPlayed) is a
    // valid hand to be played
    final cardRules = CardRules(cards: totalCardsBeingPlayed);
    var result = cardRules.play();

    // It is a valid hand
    if (result == "success") {
      DatabaseReference dbMoves =
          FirebaseDatabase.instance.ref('tables/1/moves');
      DatabaseReference newMoves = dbMoves.push();

      var update = {"uid": uid, "move": cardsBeingPlayed};

      await newMoves.set(update).then((value) {
        // Makes tapped cards on table animate to discard pile
        ref.read(isPlayButtonSelectedProvider.notifier).state = true;

        setFaceUpCardAndHand(cardsBeingPlayed.last);
      });
    } else {
      // TODO: make this more visibly known to the user that it isnt a valid hand
      // It is not a valid hand, show user that it isnt
      HapticFeedback.heavyImpact();
      HapticFeedback.heavyImpact();
    }
  }

  // TODO: is this optimal? Updating the hand? not important
  setFaceUpCardAndHand(String card) async {
    // There is at least one card
    if (cardWidgetsBuilderList.isNotEmpty) {
      List<String> cardsInHand = <String>[];
      for (int i = 0; i < cardWidgetsBuilderList.length; i++) {
        ValueKey<CardKey> t =
            cardWidgetsBuilderList[i].key! as ValueKey<CardKey>;
        cardsInHand.add(t.value.cardName!);
      }

      DatabaseReference faceUpCardRef =
          FirebaseDatabase.instance.ref('tables/1/cards');

      // update faceUPCard and player's hand
      await faceUpCardRef.update({
        'faceUpCard': card,
        'playerCards/$uid/hand': cardsInHand
      }).then((value) async {
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(isPlayButtonSelectedProvider.notifier).state = false;
          setState(() {
            tappedCards.clear();
          });
        });
        http.Response response =
            await http.get(Uri.parse("${globals.END_POINT}/table/passturn"));

        if (response.statusCode == 500) {
          // TODO: show error
        }
      });
    } else {
      // No cards left, you are the winner
      playerCardCount.remove().then((value) {
        print("removed success");
      });
    }
  }

  passPlay() async {
    // Check if player added card from deck already
    if (ref.read(didPlayerAddCardThisTurnProvider) == false) {
      await addCard();
    }

    http.Response response =
        await http.get(Uri.parse("${globals.END_POINT}/table/passturn"));

    if (response.statusCode == 500) {
      print("Error in API in table/passturn");
    }
  }

  addCard() async {
    // Why call the players starting hand again? To avoid confusion in case
    // player has any cards that are tapped and on the table/ Can this be optimized?
    // Maybe..
    // TODO: look into this, not a priority...maybe cloud function??

    //Source cardDrawnSound = AssetSource("sounds/card_drawn.mp3");
    //player.play(cardDrawnSound);

    // Updating state that the player already a card
    ref.read(didPlayerAddCardThisTurnProvider.notifier).state = true;

    final deckRef = FirebaseDatabase.instance.ref('tables/1/cards/dealer/deck');
    final playersCardsRef =
        FirebaseDatabase.instance.ref('tables/1/cards/playerCards/$uid/hand');
    final cardsRef = FirebaseDatabase.instance.ref('tables/1/cards');
    final deckEvent = await deckRef.once();
    final playerEvent = await playersCardsRef.once();

    var deck = List<String>.from(deckEvent.snapshot.value as List);
    var playersCards = List<String>.from(playerEvent.snapshot.value as List);

    var cardBeingAdded = deck[deck.length - 1];
    playersCards.add(cardBeingAdded);
    deck.removeLast();

    await cardsRef
        .update({"dealer/deck": deck, "playerCards/$uid/hand": playersCards});

    setState(() {
      isStateChanged = true;
      cardWidgetsBuilderList.add(card(CardKey(
        position: cardWidgetsBuilderList.length,
        cardName: cardBeingAdded,
      )));
    });
  }

  shuffleHand() {
    setState(() {
      isStateChanged = true;
      cardWidgetsBuilderList.shuffle();
    });
  }

  ranOutOfTime() async {
    await addCard();
    await passPlay();
  }
}
