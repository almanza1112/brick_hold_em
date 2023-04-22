import 'package:brick_hold_em/game/game_table.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:ui';

class GameCards extends StatefulWidget {
  GameCardsState createState() => GameCardsState();
}

class GameCardsState extends State<GameCards> {
  Card card1 = Card();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 70,
      child: FutureBuilder<Sprite>(
          future: getSprite(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return SpriteWidget(sprite: snapshot.data!);
            } else {
              return Text("data");
            }
          })),
    );
  }

  Future<Sprite> getSprite() async {
    Sprite sprite = await Sprite.load("backside.png");
    sprite.srcSize = Vector2(500, 700);
    return sprite;
  }
}

class Card extends SpriteComponent with Tappable {
  
}
