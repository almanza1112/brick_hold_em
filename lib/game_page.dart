import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class HomePage extends FlameGame {
  SpriteComponent background = SpriteComponent();
  SpriteComponent twoClubs = SpriteComponent();

  final double cardHeight = 70.0;
  final double cardWidth = 40.0;

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
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (twoClubs.y > size[1] / 2) {
      twoClubs.y -= 30 * dt;
    }
  }
}
