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

  @override
  Widget build(BuildContext context) {
    cardsSnapshot();
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        //fit: StackFit.expand,
        children: [GamePlayers(game: null), cardsRow()],
      ),
    );
  }

double width = 50;
  double height = 70;
  Widget cardsRow() {
    
    return Container(
      height: 70,
      child: FutureBuilder(
          future: cardsSnapshot(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              var cardsList = List<String>.from(snapshot.data as List);
      
              var cardWidgets = <Widget>[];
              for (var cards in cardsList) {
                cardWidgets.add(GestureDetector(
                  onTap: () {
                    setState(() {
                      width = 100;
                      height = 140;
                    });
                  },
                  child: AnimatedContainer(
                    alignment: Alignment(100, 0),
                    width: width,
                    height: height,
                    duration: const Duration(seconds: 1),
                    child: Image.asset(
                      "assets/images/$cards.png",
                      fit: BoxFit.cover,
                      //width: 50,
                      //height: 70,
                    ),
                  ),
                ));
              }
      
              return ListView(
                scrollDirection: Axis.horizontal,
                children: cardWidgets,
              );
            } else {
              return const Text(
                  "Something went wrong. Unable to retrieve cards.");
            }
          })),
    );
  }

  cardsSnapshot() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await onceRef.child('tables/1/cards/$uid/startingHand').get();
    if (snapshot.exists) {
      var cardsList = List<String>.from(snapshot.value as List);
      return cardsList;
    } else {
      return null;
    }
  }
}
