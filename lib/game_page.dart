import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class GamePage extends FlameGame with HasTappables{
  SpriteComponent background = SpriteComponent();
  SpriteComponent twoClubs = SpriteComponent();
  ExitButton exitButton = ExitButton();
  final Vector2 exitButtonSize = Vector2(50.0, 30.0);
  

  final double cardHeight = 70.0;
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

    twoClubs
      ..sprite = await loadSprite('2_of_clubs.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - cardHeight
      ..x = screenWidth - cardWidth;
    add(twoClubs);

    exitButton
    ..sprite = await loadSprite('exit.png')
    ..size = exitButtonSize
    ..position = Vector2(10, 10);
    add(exitButton);
    
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (twoClubs.y > size[1] / 2) {
      twoClubs.y -= 30 * dt;
    }
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);
    sampleText.render(canvas, "Sample Text", Vector2(size[0] / 2, 10));
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
