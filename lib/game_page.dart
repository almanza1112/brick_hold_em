import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:firebase_core/firebase_core.dart';

class GamePage extends FlameGame with HasTappables{
  SpriteComponent background = SpriteComponent();
  SpriteComponent twoClubs = SpriteComponent();
  SpriteComponent eightHearts = SpriteComponent();
  SpriteComponent brickCard = SpriteComponent();
  SpriteComponent fourSpade = SpriteComponent();
  SpriteComponent aceDiamond = SpriteComponent();
  SpriteComponent player2_bs1 = SpriteComponent();
  SpriteComponent player2_bs2 = SpriteComponent();
  SpriteComponent player2_bs3 = SpriteComponent();
  SpriteComponent player2_bs4 = SpriteComponent();
  SpriteComponent player2_bs5 = SpriteComponent();
  SpriteComponent player3_bs1 = SpriteComponent();
  SpriteComponent player3_bs2 = SpriteComponent();
  SpriteComponent player3_bs3 = SpriteComponent();
  SpriteComponent player3_bs4 = SpriteComponent();
  SpriteComponent player3_bs5 = SpriteComponent();

  
  ExitButton exitButton = ExitButton();
  final Vector2 exitButtonSize = Vector2(50.0, 30.0);
  
  final double cardHeight = 60.0;
  final double cardWidth = 40.0;

  TextPaint sampleText = TextPaint(style: const TextStyle(fontSize: 18));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final screenWidth = size[0];
    final screenHeight = size[1];

    add(background
      ..sprite = await loadSprite('background.webp')
      ..size = size);

    exitButton
      ..sprite = await loadSprite('exit.png')
      ..size = exitButtonSize
      ..position = Vector2(10, 10);
    add(exitButton);

    // PLAYER 1
    brickCard
      ..sprite = await loadSprite('brick_card.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - cardHeight
      ..x = screenWidth / 2.2;
    add(brickCard);

    eightHearts
      ..sprite = await loadSprite('hearts_8.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - cardHeight
      ..x = screenWidth / 2.1 ;
    add(eightHearts);

    twoClubs
      ..sprite = await loadSprite('club_2.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - cardHeight
      ..x = screenWidth / 2;
    add(twoClubs);

    fourSpade
      ..sprite = await loadSprite('spade_4.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - cardHeight
      ..x = screenWidth / 1.9;
    add(fourSpade);

    aceDiamond
      ..sprite = await loadSprite('diamond_a.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - cardHeight
      ..x = screenWidth / 1.8;
    add(aceDiamond);
    

    // PLAYER 2
    player2_bs1
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.2
      ..x = cardWidth
      ..angle = radians(270);
    add(player2_bs1);
    
    player2_bs2
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.1
      ..x = cardWidth
      ..angle = radians(270);
    add(player2_bs2);

    player2_bs3
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2
      ..x = cardWidth
      ..angle = radians(270);
    add(player2_bs3);

    player2_bs4
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 1.9
      ..x = cardWidth
      ..angle = radians(270);
    add(player2_bs4);

    player2_bs5
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 1.8
      ..x = cardWidth
      ..angle = radians(270);
    add(player2_bs5);

    // PLAYER 3
    player3_bs1
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.5
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player3_bs1);

    player3_bs2
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.4
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player3_bs2);

    player3_bs3
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.3
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player3_bs3);

    player3_bs4
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.2
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player3_bs4);

    player3_bs5
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.1
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player3_bs5);
  }

  @override
  void update(double dt) {
    super.update(dt);

    //if (twoClubs.y > size[1] / 3) {
      //twoClubs.y -= 30 * dt;
    //}
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);
    sampleText.render(canvas, "Table 1", Vector2(size[0] / 2, 10));
  }
}

class ExitButton extends SpriteComponent with Tappable {

  @override
  bool onTapDown(TapDownInfo event){
    try {
      print("object");
      
      return true;
    } catch (error){
      print(error);
      return false;
    }
  }
}
