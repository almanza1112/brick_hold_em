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

  DatabaseReference betsRef =
      FirebaseDatabase.instance.ref('tables/1/chips/bets');

  late DatabaseReference playerCardCount;

  // Create lists for the selction of the brick card. Must be in exact
  // same order as the children of ListWheelScrollView
  List<String> cardSuitsList = ['spades', 'clubs', 'hearts', 'diamonds'];
  List<String> cardNumbersList = [
    'Ace',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  // DatabaseReference cardsInHandListener = FirebaseDatabase.instance
  //     .ref('tables/1/cards/playerCards/32Zp41SqjzStoba7J6Tu2DYmk7E3/hand');

  @override
  void initState() {
    _cardsSnapshot = cardsSnapshot();
    playerCardCount =
        FirebaseDatabase.instance.ref('tables/1/cards/playerCards/$uid/hand');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build game_cards');
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
                    late bool isBrick;
                    if (cardsList[i] == 'brick') {
                      isBrick = true;
                    } else {
                      isBrick = false;
                    }
                    CardKey cardKey = CardKey(
                        position: i, cardName: cardsList[i], isBrick: isBrick);
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
        onTap: () async {
          // Check if it is player's turn
          if (ref.read(isPlayersTurnProvider)) {
            // Check if there's enough room on table for card
            if (tappedCards.length < 4) {
              // Find index of tapped cardKey (_cardKey)
              var result = cardWidgetsBuilderList
                  .indexWhere((element) => element.key == _cardKey);

              if (cardName == 'brick') {
                // Prompt user to select what they want brick card to be
                showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                        color: Colors.white,
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Select Suit and Value",
                                style: TextStyle(fontSize: 18),
                              ),
                            )),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 150,
                                    child: ListWheelScrollView(
                                        controller: FixedExtentScrollController(
                                            initialItem: ref.read(
                                                brickCardSuitPositionProvider)),
                                        itemExtent: 30,
                                        magnification: 1.8,
                                        //squeeze: 1.1,
                                        //offAxisFraction: .3,

                                        useMagnifier: true,
                                        onSelectedItemChanged: (int value) {
                                          ref
                                              .read(
                                                  brickCardSuitPositionProvider
                                                      .notifier)
                                              .state = value;
                                        },
                                        children: const [
                                          Text("Spade"),
                                          Text("Club"),
                                          Text("Heart"),
                                          Text("Diamond"),
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: ListWheelScrollView(
                                          controller: FixedExtentScrollController(
                                              initialItem: ref.read(
                                                  brickCardNumberPositionProvider)),
                                          itemExtent: 30,
                                          magnification: 1.8,
                                          //squeeze: 1.1,
                                          //offAxisFraction: -0.3,
                                          useMagnifier: true,
                                          physics: const BouncingScrollPhysics(
                                            parent:
                                                AlwaysScrollableScrollPhysics(),
                                          ),
                                          onSelectedItemChanged: (int value) {
                                            ref
                                                .read(
                                                    brickCardNumberPositionProvider
                                                        .notifier)
                                                .state = value;
                                          },
                                          children: cardNumbersList
                                              .map((e) => Text(e))
                                              .toList()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              child: const Text("Confirm"),
                              onPressed: () {
                                // Handle confirmation logic here

                                // Get key of card
                                ValueKey<CardKey> t =
                                    cardWidgetsBuilderList[result].key
                                        as ValueKey<CardKey>;

                                // Obtain selected brick cards name
                                String newCardName =
                                    '${cardSuitsList[ref.read(brickCardSuitPositionProvider)]}${cardNumbersList[ref.read(brickCardNumberPositionProvider)]}';

                                // Create widget for new card
                                Widget brickCard = card(
                                    t.value.copyWith(cardName: newCardName));

                                setState(
                                  () {
                                    isStateChanged = true;

                                    // Add tapped card to table (tappedCards List)
                                    tappedCards.add(brickCard);

                                    // Remove tapped card from hand (cardWigetsBuilderList)
                                    cardWidgetsBuilderList.removeWhere(
                                        (element) => element.key == _cardKey);
                                  },
                                );

                                Navigator.of(context).pop(); // Close the modal
                              },
                            ),
                          ],
                        )));
              } else {
                setState(() {
                  isStateChanged = true;

                  // Add tapped card to table (tappedCards List)
                  tappedCards.add(cardWidgetsBuilderList[result]);

                  // Remove tapped card from hand (cardWigetsBuilderList)
                  cardWidgetsBuilderList
                      .removeWhere((element) => element.key == _cardKey);
                });
              }
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
              // Get key of the tapped card
              ValueKey<CardKey> t = tappedCards[pos].key as ValueKey<CardKey>;

              late Widget newCard;

              // Check if it is a Brick card
              if (t.value.isBrick!) {
                // If it is than make the new card Brick
                newCard = card(t.value.copyWith(cardName: 'brick'));
              } else {
                // If it isn't then its a regular card, proceed as normal
                newCard = tappedCards[pos];
              }

              setState(() {
                cardWidgetsBuilderList.add(newCard);
                tappedCards.removeAt(pos);
              });
            },
            onLongPress: () {
              ValueKey<CardKey> theTappedCard =
                  tappedCards[pos].key as ValueKey<CardKey>;
              if (theTappedCard.value.isBrick!) {
                showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                        color: Colors.white,
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Select Suit and Value",
                                style: TextStyle(fontSize: 18),
                              ),
                            )),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 150,
                                    child: ListWheelScrollView(
                                        controller: FixedExtentScrollController(
                                            initialItem: ref.read(
                                                brickCardSuitPositionProvider)),
                                        itemExtent: 30,
                                        magnification: 1.8,
                                        //squeeze: 1.1,
                                        //offAxisFraction: .3,

                                        useMagnifier: true,
                                        onSelectedItemChanged: (int value) {
                                          ref
                                              .read(
                                                  brickCardSuitPositionProvider
                                                      .notifier)
                                              .state = value;
                                        },
                                        children: const [
                                          Text("Spade"),
                                          Text("Club"),
                                          Text("Heart"),
                                          Text("Diamond"),
                                        ]),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: ListWheelScrollView(
                                          controller: FixedExtentScrollController(
                                              initialItem: ref.read(
                                                  brickCardNumberPositionProvider)),
                                          itemExtent: 30,
                                          magnification: 1.8,
                                          //squeeze: 1.1,
                                          //offAxisFraction: -0.3,
                                          useMagnifier: true,
                                          physics: const BouncingScrollPhysics(
                                            parent:
                                                AlwaysScrollableScrollPhysics(),
                                          ),
                                          onSelectedItemChanged: (int value) {
                                            ref
                                                .read(
                                                    brickCardNumberPositionProvider
                                                        .notifier)
                                                .state = value;
                                          },
                                          children: cardNumbersList
                                              .map((e) => Text(e))
                                              .toList()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              child: const Text("Confirm"),
                              onPressed: () {
                                // Handle confirmation logic here

                                // Get key of card
                                ValueKey<CardKey> t =
                                    tappedCards[pos].key as ValueKey<CardKey>;
                                String newCardName =
                                    '${cardSuitsList[ref.read(brickCardSuitPositionProvider)]}${cardNumbersList[ref.read(brickCardNumberPositionProvider)]}';

                                setState(
                                  () {
                                    isStateChanged = true;
                                    tappedCards[pos] = card(CardKey(
                                        position: t.value.position,
                                        cardName: newCardName,
                                        isBrick: t.value.isBrick));
                                  },
                                );

                                Navigator.of(context).pop(); // Close the modal
                              },
                            ),
                          ],
                        )));
              }
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
          var map = event.snapshot.value! as Map<Object?, Object?>;
          var d = map[map.keys.first] as List<Object?>;
          return Image.asset(
            "assets/images/${d[0]}.png",
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
                    IconButton(
                        onPressed: shuffleHand,
                        icon: const Icon(
                          Icons.shuffle,
                          color: Colors.amber,
                          size: 36,
                        )),
                    IconButton(
                        onPressed: passPlay,
                        icon: const Icon(
                          Icons.check,
                          color: Colors.amber,
                          size: 36,
                        )),
                    IconButton(
                        onPressed: playButton,
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.amber,
                          size: 36,
                        )),
                    IconButton(
                        onPressed: betModal,
                        icon: const Icon(
                          Icons.paid,
                          color: Colors.amber,
                          size: 36,
                        )),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        onPressed: shuffleHand,
                        icon: const Icon(
                          Icons.shuffle,
                          color: Colors.amber,
                          size: 36,
                        )),
                    IconButton(
                        onPressed: betModal,
                        icon: const Icon(
                          Icons.paid,
                          color: Colors.amber,
                          size: 36,
                        )),
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
    final map =
        faceUpCardRefOnce.asData!.value.snapshot.value as Map<Object?, Object?>;
    var data = map[map.keys.first] as List<Object?>;

    // Create empty list for cards that are being played (tapped cards)
    List<String> cardsBeingPlayed = <String>[];

    // Loop through tappCards list to populate cardsBeingPlayed list
    for (int i = 0; i < tappedCards.length; i++) {
      ValueKey<CardKey> t = tappedCards[i].key! as ValueKey<CardKey>;
      cardsBeingPlayed.add(t.value.cardName!);
    }

    // Create list that adds faceUpCard
    List<String> totalCardsBeingPlayed = [
      data[0].toString(),
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
        //'faceUpCard': card,
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

  double currentSliderValue = 200;

  void betModal() {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              color: Colors.green,
              child: Material(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Center(
                          child: Text(
                        'Bet',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none),
                      )),
                      const Expanded(child: SizedBox.shrink()),
                      StatefulBuilder(builder: (context, setState) {
                        return Column(
                          children: [
                            Slider(
                                max: 1000,
                                thumbColor: Colors.amber,
                                activeColor: Colors.amber,
                                inactiveColor: Colors.white,
                                value: currentSliderValue,
                                onChanged: (value) {
                                  setState(() {
                                    currentSliderValue = value;
                                  });
                                }),
                            Text(currentSliderValue.round().toString())
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 36,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(24)),
                              onPressed: foldHand,
                              child: const Text(
                                'FOLD',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(24)),
                              onPressed: raiseBet,
                              child: const Text(
                                'RAISE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(24)),
                              onPressed: callBet,
                              child: const Text(
                                'CALL',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  void raiseBet() async {
    var body = {
      'uid': uid,
      'bet': currentSliderValue.round().toString(),
      'position': ref.read(playerPositionProvider).toString()
    };

    http.Response response = await http
        .post(Uri.parse('${globals.END_POINT}/table/raiseBet'), body: body);

    if (response.statusCode == 201) {
      // Udpate UI
    } else {
      print("error folding hand");
      print('statusCode: ${response.statusCode}');
    }
  }

  void callBet() async {}

  void foldHand() async {
    var body = {
      'uid': uid,
      'position': ref.read(playerPositionProvider).toString()
    };

    http.Response response = await http
        .post(Uri.parse('${globals.END_POINT}/table/foldhand'), body: body);

    if (response.statusCode == 201) {
      // Update UI
    } else {
      print("error folding hand");
      print('statusCode: ${response.statusCode}');
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

    late bool isBrick;
    if (cardBeingAdded == 'brick') {
      isBrick = true;
    } else {
      isBrick = false;
    }

    await cardsRef
        .update({"dealer/deck": deck, "playerCards/$uid/hand": playersCards});

    setState(() {
      isStateChanged = true;
      cardWidgetsBuilderList.add(card(CardKey(
          position: cardWidgetsBuilderList.length,
          cardName: cardBeingAdded,
          isBrick: isBrick)));
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
