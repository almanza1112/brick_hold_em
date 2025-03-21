import 'dart:convert';

import 'package:brick_hold_em/game/animations/bouncing_icon_button.dart';
import 'package:brick_hold_em/game/card_rules.dart';
import 'package:brick_hold_em/game/deck_card.dart';
import 'package:brick_hold_em/game/table_card.dart';
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

class GameCardsPageState extends ConsumerState<GameCards>
    with AutomaticKeepAliveClientMixin {
  final onceRef = FirebaseDatabase.instance.ref();
  var cardWidgetsBuilderList = <Widget>[];
  double handCardWidth = 50;
  double handCardHeight = 70;
  double tableCardWidth = 40;
  double tableCardHeight = 56;
  final double tableCardsYPos = 350;

  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<Widget> tappedCards = <Widget>[];

  final player = AudioPlayer();

  Duration tableCardAnimationDuration = const Duration(milliseconds: 250);

  late double constrainHeight, constrainWidth;

  DatabaseReference faceUpCardListener =
      FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');

  DatabaseReference deckCountListener =
      FirebaseDatabase.instance.ref('tables/1/cards/dealer/deckCount');

  DatabaseReference potListener =
      FirebaseDatabase.instance.ref('tables/1/betting/pot');

  late DatabaseReference userChipCountListener;
  late DatabaseReference userChipCountRef;

  DatabaseReference movesRef = FirebaseDatabase.instance.ref('tables/1/moves');

  DatabaseReference toCallRef =
      FirebaseDatabase.instance.ref('tables/1/betting/toCall');

  late DatabaseReference playerCardCount;

  Future<DataSnapshot>? _handRefFuture;

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

  double currentSliderValue = 0;
  double chipsImageWidth = 70;
  double userChipsStartingPosYBottom = 190;
  bool userChipsToTableVisibility = false;

  @override
  void initState() {
    super.initState();
    playerCardCount =
        FirebaseDatabase.instance.ref('tables/1/cards/playerCards/$uid/hand');

    userChipCountListener =
        FirebaseDatabase.instance.ref('tables/1/chips/$uid/chipCount');

    userChipCountRef = FirebaseDatabase.instance.ref('tables/1/chips/$uid/');

    _handRefFuture = FirebaseDatabase.instance
        .ref(
            'tables/1/cards/playerCards/${FirebaseAuth.instance.currentUser!.uid}/hand')
        .get(); // Cache the future in initState
  }

  // This is with AutomaticKeepAliveClientMixin and is meant to avoid unnecessary
  // rebuilds of the widget when keyboard is opened/closed
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: ((BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            playerCards(),
            fiveCardBorders(constraints),
            faceUpCard(constraints),
            deck(constraints),
            buttons(),
            animatedChipsToTable(constraints),
            userChips(constraints),
            tableChips(constraints),
          ],
        );
      }),
    );
  }

  Widget playerCards() {
    //final refreshKey = ref.watch(refreshKeyProvider);
    // TODO: this is not optimal but a temporary patch
    // Future<DataSnapshot> handRef = FirebaseDatabase.instance
    //     .ref(
    //         'tables/1/cards/playerCards/${FirebaseAuth.instance.currentUser!.uid}/hand')
    //     .get();
    return SafeArea(
      //key: ref.watch(refreshKeyProvider), // TODO: why do i need this?
      child: Stack(children: [
        Positioned(
          right: 0,
          bottom: 100,
          left: 0,
          child: FutureBuilder(
              future: _handRefFuture,
              builder: ((context, snapshot) {
                print('playerCards() called');
                if (snapshot.hasData) {
                  var cardsList =
                      List<String>.from(snapshot.data!.value as List);
                  //print("cardList: $cardsList");

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

                  if (!ref.read(didUserMoveCardProvider)) {
                    cardWidgetsBuilderList = cardWidgets;
                  }

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

  Widget deck(var constraints) {
    return Positioned(
      top: tableCardsYPos,
      left: (constraints.constrainWidth() / 2) - ((tableCardWidth * 3) + 20),
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
            child: StatefulBuilder(builder: (context, snapshot) {
              return Stack(
                children: [
                  const DeckCard(),
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
              );
            }),
          )),
    );
  }

  Widget fiveCardBorders(var constraints) {
    return Stack(
      children: [
        // Red dot posiition 1
        Positioned(
            top: tableCardsYPos,
            left: (constraints.constrainWidth() / 2) -
                ((tableCardWidth * 2) + 10),
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
            top: tableCardsYPos,
            left:
                (constraints.constrainWidth() / 2) - ((tableCardWidth * 1) + 5),
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
            top: tableCardsYPos,
            left: (constraints.constrainWidth() / 2),
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
            top: tableCardsYPos,
            left:
                (constraints.constrainWidth() / 2) + ((tableCardWidth * 1) + 5),
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
            top: tableCardsYPos,
            left: (constraints.constrainWidth() / 2) +
                ((tableCardWidth * 2) + 10),
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
            top: tableCardsYPos,
            left: (constraints.constrainWidth() / 2) -
                ((tableCardWidth * 2.5) + 10),
            child: const SizedBox(
              height: 70,
              width: 50,
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.yellowAccent)),
            )),

        // Card position #2
        AnimatedPositioned(
            top: tableCardsYPos,
            left: ref.read(isPlayButtonSelectedProvider)
                ? (constraints.constrainWidth() / 2) -
                    ((tableCardWidth * 2) + 10)
                : (constraints.constrainWidth() / 2) -
                    ((tableCardWidth * 1) + 5),
            duration: tableCardAnimationDuration,
            child: SizedBox(
              //margin: const EdgeInsets.all(15.0),
              height: tableCardHeight,
              width: tableCardWidth,
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.yellowAccent)),
              child: tableCard(0),
            )),

        // Card position #3
        AnimatedPositioned(
            top: tableCardsYPos,
            left: ref.read(isPlayButtonSelectedProvider)
                ? (constraints.constrainWidth() / 2) -
                    ((tableCardWidth * 2) + 10)
                : (constraints.constrainWidth() / 2),
            duration: tableCardAnimationDuration,
            child: SizedBox(
              //margin: const EdgeInsets.all(15.0),
              height: tableCardHeight,
              width: tableCardWidth,
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.yellowAccent)),
              child: tableCard(1),
            )),

        // Card position #4
        AnimatedPositioned(
            top: tableCardsYPos,
            left: ref.read(isPlayButtonSelectedProvider)
                ? (constraints.constrainWidth() / 2) -
                    ((tableCardWidth * 2) + 10)
                : (constraints.constrainWidth() / 2) +
                    ((tableCardWidth * 1) + 5),
            duration: tableCardAnimationDuration,
            child: SizedBox(
              //margin: const EdgeInsets.all(15.0),
              height: tableCardHeight,
              width: tableCardWidth,
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.yellowAccent)),
              child: tableCard(2),
            )),

        //Card position #5
        AnimatedPositioned(
            top: tableCardsYPos,
            left: ref.read(isPlayButtonSelectedProvider)
                ? (constraints.constrainWidth() / 2) -
                    ((tableCardWidth * 2) + 10)
                : (constraints.constrainWidth() / 2) +
                    ((tableCardWidth * 2) + 10),
            duration: tableCardAnimationDuration,
            child: SizedBox(
              //margin: const EdgeInsets.all(15.0),
              height: tableCardHeight,
              width: tableCardWidth,
              //decoration: BoxDecoration(
              //border: Border.all(color: Colors.yellowAccent)),
              child: tableCard(3),
            )),
      ],
    );
  }

  Widget card(CardKey cardKey) {
    String cardName = cardKey.cardName!;
    var cardKey0 = ValueKey(cardKey);

    return SizedBox(
      key: cardKey0,
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
                  .indexWhere((element) => element.key == cardKey0);

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

                                // THIS IS IMPORTANT FOR WHEN GAME RESTARTS
                                // MUST GGO ALONG WITH setState() BELOW
                                ref
                                    .read(didUserMoveCardProvider.notifier)
                                    .state = true;

                                setState(
                                  () {
                                    // Add tapped card to table (tappedCards List)
                                    tappedCards.add(brickCard);

                                    // Remove tapped card from hand (cardWigetsBuilderList)
                                    cardWidgetsBuilderList.removeWhere(
                                        (element) => element.key == cardKey0);
                                  },
                                );

                                Navigator.of(context).pop(); // Close the modal
                              },
                            ),
                          ],
                        )));
              } else {
                // Play card sliding sound
                //Source cardSlidingSound =
                    AssetSource("sounds/card_sliding.mp3");
                //player.play(cardSlidingSound);

                // THIS IS IMPORTANT FOR WHEN GAME RESTARTS
                // MUST GGO ALONG WITH setState() BELOW
                ref.read(didUserMoveCardProvider.notifier).state = true;

                setState(() {
                  // Add tapped card to table (tappedCards List)
                  tappedCards.add(cardWidgetsBuilderList[result]);

                  // Remove tapped card from hand (cardWigetsBuilderList)
                  cardWidgetsBuilderList
                      .removeWhere((element) => element.key == cardKey0);
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
      return TableCard(
        child: tableCardDesign(pos),
      );
    } else {
      return null;
    }
  }

  Widget tableCardDesign(int pos) {
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
              // Play card sliding sound
              //Source cardSlidingSound = AssetSource("sounds/card_sliding.mp3");
              //player.play(cardSlidingSound);

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
                                            .read(brickCardSuitPositionProvider
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

                              // THIS IS IMPORTANT FOR WHEN GAME RESTARTS
                              // MUST GGO ALONG WITH setState() BELOW
                              ref.read(didUserMoveCardProvider.notifier).state =
                                  true;

                              setState(
                                () {
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
  }

  Widget tableChips(var constraints) {
    return Positioned(
        top: 180,
        left: (constraints.constrainWidth() / 2) - (100 / 2),
        child: SizedBox(
          width: 100,
          height: 100,
          child: StreamBuilder(
              stream: potListener.onValue,
              builder: (((context, snapshot) {
                if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  var data =
                      snapshot.data!.snapshot.value as Map<Object?, Object?>;
                  return Stack(
                    children: [
                      Center(
                          child: Image.asset(
                        'assets/images/casino-chips.png',
                        width: 50,
                      )),
                      Center(
                        child: Text(
                          "${data['pot1']}",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Text('...');
                }
              }))),
        ));
  }

  Widget faceUpCard(var constraints) {
    // commented out since position will be relative to top of the screen and not the center
    //constrainHeight = constraints.constrainHeight();
    return Stack(
      children: [
        Positioned(
            //top: (constraints.constrainHeight() / 2) + 50,
            top: tableCardsYPos,
            left: (constraints.constrainWidth() / 2) -
                ((tableCardWidth * 2) + 10),
            child: GestureDetector(
                onTap: getPreviousMove, child: faceUpCardImage()))
      ],
    );
  }

  Widget faceUpCardImage() {
    final liveFaceUpCard = ref.watch(faceUpCardProvider);

    return liveFaceUpCard.when(
        data: (event) {
          var map = event.snapshot.value! as Map<Object?, Object?>;
          var d = map[map.keys.first] as List<Object?>;
          return Image.asset(
            "assets/images/${d[d.length - 1]}.png",
            width: tableCardWidth,
            height: tableCardHeight,
          );
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => const CircularProgressIndicator());
  }

  getPreviousMove() async {
    movesRef.limitToLast(1).get().then((snapshot) {
      final map = snapshot.value as Map<dynamic, dynamic>;
      final key = map.keys;
      List<dynamic> move = map[key.first]['move'];
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text("Last Move"),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 100,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: move.map((imageName) {
                      return Image.asset(
                        "assets/images/$imageName.png",
                        height: 56,
                        width: 40,
                      );
                    }).toList(),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              )));
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
              bottom: 40,
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
                        onPressed: play,
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.amber,
                          size: 36,
                        )),
                    //betButton()
                  ],
                ),
              ),
            );
          } else {
            return Positioned(
                left: leftPosition,
                right: rightPosition,
                bottom: 40,
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
                    //betButton()
                  ],
                ));
          }
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  play() async {
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
      data[data.length - 1].toString(),
      ...cardsBeingPlayed
    ];

    // Make sure list with the faceUpCard(totalCardsBeingPlayed) is a
    // valid hand to be played
    final cardRules = CardRules(cards: totalCardsBeingPlayed);
    var result = cardRules.play();

    // It is a valid play
    if (result == "success") {
      // Play valid sound
      //Source validPlaySound = AssetSource("sounds/valid.wav");
      //player.play(validPlaySound);

      // Makes tapped cards on table animate to discard pile
      ref.read(isPlayButtonSelectedProvider.notifier).state = true;

      // There is at least one card in hand
      if (cardWidgetsBuilderList.isNotEmpty) {
        // Create list of cards that are in hand that will be sent to server
        List<String> cardsInHand = <String>[];

        // Loop through current cards in hand list
        for (int i = 0; i < cardWidgetsBuilderList.length; i++) {
          // Get key of each card
          ValueKey<CardKey> t =
              cardWidgetsBuilderList[i].key! as ValueKey<CardKey>;

          // Add each card name into list
          cardsInHand.add(t.value.cardName!);
        }
        // Create post body
        var body = {
          'uid': uid,
          'move': totalCardsBeingPlayed.toString(),
          'cardsToDiscard': cardsBeingPlayed.toString(),
          'cardsInHand': cardsInHand.toString(),
          'position': ref.read(playerPositionProvider).toString(),
        };

        // Check if you need to call or raise
        if (ref.read(doYouNeedToCallProvider)) {
          // Check if there is a bet pending with play
          // if (ref.read(isThereABetProvider) == true) {
          //   //String typeOfBet = ref.read(typeOfBetProvider);
          //   late String amountOfBet;

          //   // if (typeOfBet == "raise") {
          //   //   amountOfBet = currentSliderValue.round().toString();
          //   // }

          //   // if (typeOfBet == "call") {
          //   //   amountOfBet = ref.read(toCallAmmount);
          //   // }
          //   var bet = {
          //     //'type': ref.read(typeOfBetProvider),
          //     //'amount': amountOfBet
          //   };

          //   body['bet'] = jsonEncode(bet);

          //   startChipsAnimation();
          //   sendPlay(body);
          // } else {
          //   // There is no bet or call made, prompt user
          //   var snackBar = SnackBar(
          //     content: const Text('You need to either call or raise'),
          //     dismissDirection: DismissDirection.up,
          //     behavior: SnackBarBehavior.floating,
          //     margin: EdgeInsets.only(
          //       bottom: MediaQuery.of(context).size.height - 130,
          //       left: 10,
          //       right: 10,
          //     ),
          //   );

          //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // }
        } else {
          // You don't need to call or raise

          // Check if there is a bet pending with play
          // if (ref.read(isThereABetProvider) == true) {
          //   var bet = {
          //     //'type': ref.read(typeOfBetProvider),
          //     'amount': currentSliderValue.round().toString()
          //   };

          //   body['bet'] = jsonEncode(bet);

          //   // Since there is a bet user is making, start the
          //   // animation of the chips to table
          //   startChipsAnimation();
          // }
          sendPlay(body);
        }
      } else {
        // No cards left, you are the winner
        playerCardCount.remove().then((value) {
          print("removed success");
        });
      }
    } else {
      // TODO: make this more visibly known to the user that it isnt a valid hand
      // It is not a valid hand, show user that it isnt
      ref.read(isThereAnInvalidPlayProvider.notifier).state = true;

      // Play invalid sound
     //Source invalidPlaySound = AssetSource("sounds/invalid.wav");
      //player.play(invalidPlaySound);

      // Vibrate phone
      HapticFeedback.heavyImpact();
      HapticFeedback.heavyImpact();
    }
  }

  void sendPlay(var body) async {
    // Send post request
    http.Response playCardsResponse = await http
        .post(Uri.parse("${globals.END_POINT}/table/playCards"), body: body);

    if (playCardsResponse.statusCode == 201) {
      // Success

      // Reset provider
      //ref.read(isThereABetProvider.notifier).state = false;

      // Update UI
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(isPlayButtonSelectedProvider.notifier).state = false;
        setState(() {
          tappedCards.clear();
        });
      });
    } else {
      // There is an error
    }
  }

  // Okay so the only reason I am making a separate widget function for the bet button instead
  // of just using a tenary operation inside the color and just calling ref.read(doYouNeedToCallProvider)
  // is because this way it GUARANTEES that the button changes.
  // Biggest concern was buttons() resolving before the provider could update itself.
  Widget betButton() {
    return StreamBuilder(
        stream: toCallRef.onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            // TODO: Show errror
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.snapshot.value == null) {
            // The round or game just started OR there is no pot and there is nothing to be called.

            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(doYouNeedToCallProvider.notifier).state = false;

              //ref.read(toCallAmmount.notifier).state = "0";
            });
            return IconButton(
                onPressed: betModal,
                icon: const Icon(
                  Icons.paid,
                  color: Colors.amber,
                  size: 36,
                ));
          } else {
            // There is a bet, now determine if it is a bet you just made and other players are
            // just calling and if it hasnt made a full circle
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            bool didAFullCircle = data['didAFullCircle'] as bool;

            late bool doYouNeedToCall;

            // only show bouncing icon when a full circle was not complete
            if (!didAFullCircle) {
              // Did not do a full circle

              // Check now if its your bet or not
              if (data['uid'] == uid) {
                doYouNeedToCall = false;
              } else {
                doYouNeedToCall = true;
              }
            } else {
              // It did a full circle
              doYouNeedToCall = false;
            }

            print("bet check");

            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(doYouNeedToCallProvider.notifier).state =
                  doYouNeedToCall;

              if (doYouNeedToCall) {
                // ref.read(toCallAmmount.notifier).state =
                //     data['amount'] as String;
              }
            });

            if (doYouNeedToCall) {
              return GestureDetector(
                onTap: betModal,
                child: BouncingIcon(
                  icon: Icons.paid,
                  color: didAFullCircle ? Colors.amber : Colors.blue,
                  size: 36,
                ),
              );
            } else {
              return IconButton(
                  onPressed: betModal,
                  icon: const Icon(
                    Icons.paid,
                    color: Colors.amber,
                    size: 36,
                  ));
            }
          }
        });
  }

  void betModal() {}

  Widget userChips(var constraints) {
    return Positioned(
        bottom: 190,
        left: (constraints.constrainWidth() / 2) - (chipsImageWidth / 2),
        child: SizedBox(
          width: chipsImageWidth,
          height: chipsImageWidth,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/casino-chips.png',
                width: chipsImageWidth,
              ),
              Center(
                  child: StreamBuilder(
                      stream: userChipCountListener.onValue,
                      builder: (((context, snapshot) {
                        if (snapshot.hasError) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData) {
                          int count = (snapshot.data!).snapshot.value as int;

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            double playerChipCount = count.toDouble();
                            ref.read(playerChipCountProvider.notifier).state =
                                playerChipCount;
                          });
                          return Text(
                            "$count",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          );
                        } else {
                          return const Text("...");
                        }
                      }))))
            ],
          ),
        ));
  }

  Widget animatedChipsToTable(var constraints) {
    return Visibility(
      visible: userChipsToTableVisibility,
      child: AnimatedPositioned(
        left: (constraints.constrainWidth() / 2) - (50 / 2),
        bottom: userChipsStartingPosYBottom,
        duration: const Duration(milliseconds: 500),
        onEnd: () {
          setState(() {
            userChipsToTableVisibility = false;
          });
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {
              userChipsStartingPosYBottom = 190;
            });
          });
        },
        child: Image.asset(
          'assets/images/casino-chips.png',
          width: 50,
        ),
      ),
    );
  }

  void startChipsAnimation() {
    setState(() {
      userChipsToTableVisibility = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        userChipsStartingPosYBottom = 500;
      });
    });
  }

  void foldHand() async {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text("Fold Hand"),
              content: const Text('Are you sure you want to fold?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCEL")),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      var body = {
                        'uid': uid,
                        'position': ref.read(playerPositionProvider).toString()
                      };

                      http.Response response = await http.post(
                          Uri.parse('${globals.END_POINT}/table/foldhand'),
                          body: body);

                      if (response.statusCode == 201) {
                        // Update UI
                      } else {
                        print("error folding hand");
                        print('statusCode: ${response.statusCode}');
                      }
                    },
                    child: const Text("YES"))
              ],
            )));
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
    // player.play(cardDrawnSound);

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

    startChipsAnimation();
    print(ref.read(playerChipCountProvider));

    await cardsRef
        .update({"dealer/deck": deck, "playerCards/$uid/hand": playersCards});

    await userChipCountRef.update({'chipCount': ref.read(playerChipCountProvider) - 10});

    await potListener.update({'pot1': 10});

    // THIS IS IMPORTANT FOR WHEN GAME RESTARTS
    // MUST GGO ALONG WITH setState() BELOW
    ref.read(didUserMoveCardProvider.notifier).state = true;

    setState(() {
      cardWidgetsBuilderList.add(card(CardKey(
          position: cardWidgetsBuilderList.length,
          cardName: cardBeingAdded,
          isBrick: isBrick)));
    });
  }

  shuffleHand() {
    // THIS IS IMPORTANT FOR WHEN GAME RESTARTS
    // MUST GGO ALONG WITH setState() BELOW
    ref.read(didUserMoveCardProvider.notifier).state = true;

    setState(() {
      cardWidgetsBuilderList.shuffle();
    });
  }

  ranOutOfTime() async {
    await addCard();
    await passPlay();
  }
}
