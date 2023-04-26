import 'package:brick_hold_em/game/game_players.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  final onceRef = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    getFaceUpCard();
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        //fit: StackFit.expand,
        children: [GamePlayers(game: null), playerCards(), deck(), faceUpCard(), buttons()],
      ),
    );
  }

  double width = 50;
  double height = 70;
  var cardWidgets = <Widget>[];

  Widget playerCards() {
    return SafeArea(
      child: Stack(children: [
        Positioned(
          right: 0,
          bottom: 50,
          left: 0,
          child: FutureBuilder(
              future: cardsSnapshot(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  var cardsList = List<String>.from(snapshot.data as List);

                  for (var cards in cardsList) {
                    cardWidgets.add(card(cards));
                  }

                  return Container(
                    //color: Colors.amber,
                    height: 70,
                    //alignment: Alignment.bottomCenter,
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

  double boxX = -1;
  double boxY = -1;
  void moveBox() {
    setState(() {
      boxX = 1;
      boxY = 1;
    });
  }

  // Just in case i mess up
  Widget whatItShouldLookLike() {
    return SafeArea(
      child: Stack(children: [
        Positioned(
          right: 0,
          bottom: 0,
          left: 0,
          child: Container(
            //color: Colors.amber,
            height: 70,
            //alignment: Alignment.bottomCenter,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                //children: cardWidgets,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // TESTING
  Widget posWid() {
    return SafeArea(
      child: Stack(children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 70,
            color: Colors.amber,
            alignment: Alignment.center,
            child: ListView(
              scrollDirection: Axis.horizontal,
              //shrinkWrap: true,
              children: [
                GestureDetector(
                    onTap: () {
                      moveBox();
                    },
                    child: AnimatedContainer(
                      //alignment: Alignment(boxX, boxY),
                      transform: Matrix4.translationValues(30, -100, 0),
                      duration: Duration(seconds: 1),
                      child: Text("somethinggggggggg"),
                    )),
                Text("something")
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget card(var card) {
    return GestureDetector(
      onTap: () {
        setState(() {
          width = 100;
          height = 140;
        });
      },
      child: AnimatedContainer(
        //color: Colors.black,
        //alignment: Alignment(100, 0),
        width: width,
        height: height,
        duration: const Duration(seconds: 1),
        child: Image.asset(
          "assets/images/$card.png",
          fit: BoxFit.cover,
          width: 50,
          height: 70,
        ),
      ),
    );
  }

  cardsSnapshot() async {
    final snapshot =
        await onceRef.child('tables/1/cards/$uid/startingHand').get();
    if (snapshot.exists) {
      var cardsList = List<String>.from(snapshot.value as List);
      return cardsList;
    } else {
      return null;
    }
  }

  Widget deck(){
    return Center(
      child: Image.asset(
        "assets/images/backside.png",
        fit: BoxFit.cover,
        width: 50,
        height: 70,
      )
    );
  }

  Widget faceUpCard() {
    
    return SafeArea(child: LayoutBuilder(
      builder: ((BuildContext context, BoxConstraints constraints ) {
      return Stack(
        children: [
          Positioned(
            top: (constraints.constrainHeight() / 2) + 100,
            left: constraints.constrainWidth() / 2,
            child: Text("help me"))
        ],
      );
    })
    )
    );
  }

  getFaceUpCard() async {
    DatabaseReference faceUpCardRef =
        FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');
    faceUpCardRef.onValue.listen((event) async {
      var _faceUpCardList = List<String>.from(event.snapshot.value as List);
      //faceUpCardList = _faceUpCardList;
      print(_faceUpCardList[0]);
      
    });
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
      cardWidgets.add(card(cardBeingAdded));
    });
  }
}
