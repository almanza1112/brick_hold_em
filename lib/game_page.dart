import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:firebase_core/firebase_core.dart';

List<String> cardsSelected = [];

class GamePage extends FlameGame with HasTappables {
  SpriteComponent background = SpriteComponent();
  late Cards twoClubs;
  late Cards eightHearts;
  late Cards brickCard;
  late Cards fourSpade;
  late Cards aceDiamond;

  // User is Player 1, going counter clockwise players are numbered
  // Player 2
  SpriteComponent player2Card1 = SpriteComponent();
  SpriteComponent player2Card2 = SpriteComponent();
  SpriteComponent player2Card3 = SpriteComponent();
  SpriteComponent player2Card4 = SpriteComponent();
  // Player 3
  SpriteComponent player3Card1 = SpriteComponent();
  SpriteComponent player3Card2 = SpriteComponent();
  SpriteComponent player3Card3 = SpriteComponent();
  SpriteComponent player3Card4 = SpriteComponent();
  // Player 4
  SpriteComponent player4Card1 = SpriteComponent();
  SpriteComponent player4Card2 = SpriteComponent();
  SpriteComponent player4Card3 = SpriteComponent();
  SpriteComponent player4Card4 = SpriteComponent();
  // Player 5
  SpriteComponent player5Card1 = SpriteComponent();
  SpriteComponent player5Card2 = SpriteComponent();
  SpriteComponent player5Card3 = SpriteComponent();
  SpriteComponent player5Card4 = SpriteComponent();

  ExitButton exitButton = ExitButton();
  CancelButton cancelButton = CancelButton();
  CheckButton checkButton = CheckButton();
  final Vector2 exitButtonSize = Vector2(50.0, 30.0);

  final double cardHeight = 40.0;
  final double cardWidth = 25.0;

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
    brickCard = Cards()
      ..sprite = await loadSprite('brick_card.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 2.2;
    add(brickCard);

    eightHearts = Cards()
      ..sprite = await loadSprite('hearts_8.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 2.1;
    add(eightHearts);

    twoClubs = Cards()
      ..sprite = await loadSprite('club_2.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 2;
    add(twoClubs);

    fourSpade = Cards()
      ..sprite = await loadSprite('spade_4.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 1.9;
    add(fourSpade);

    aceDiamond = Cards()
      ..sprite = await loadSprite('diamond_a.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 1.8;
    add(aceDiamond);

    // PLAYER 2
    player2Card1
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - 60
      ..x = screenWidth - 200
      ..angle = radians(315);
    add(player2Card1);

    player2Card2
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.1
      ..x = cardWidth
      ..angle = radians(315);
    add(player2Card2);

    player2Card3
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2
      ..x = cardWidth
      ..angle = radians(315);
    add(player2Card3);

    player2Card4
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 1.9
      ..x = cardWidth
      ..angle = radians(315);
    add(player2Card4);

    // Player 3
    player3Card1
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 1.8
      ..x = cardWidth
      ..angle = radians(270);
    add(player3Card1);

    player3Card2
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.5
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player3Card2);

    player3Card3
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.4
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player3Card3);

    player3Card4
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.3
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player3Card4);

    // Player 4
    player4Card1
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.2
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player4Card1);

    player4Card2
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.1
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player4Card2);

    player4Card3
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.2
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player4Card3);

    player4Card4
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.1
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player4Card4);

    // Player 5
    player5Card1
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.2
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player5Card1);

    player5Card2
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.1
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player5Card2);

    player5Card3
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.2
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player5Card3);

    player5Card4
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight / 2.1
      ..x = screenWidth - cardWidth
      ..angle = radians(90);
    add(player5Card4);

    cancelButton
      ..sprite = await loadSprite("cancel.png")
      ..size = Vector2(50, 50)
      ..y = screenHeight
      ..x = screenWidth;
    add(cancelButton);

    checkButton
      ..sprite = await loadSprite("check.png")
      ..size = Vector2(50, 50)
      ..y = screenHeight
      ..x = screenWidth;
    add(checkButton);
  }

  @override
  void update(double dt) {
    super.update(dt);

    //if (twoClubs.y > size[1] / 3) {
    //twoClubs.y -= 30 * dt;
    //}
    //print(aceDiamond.isExpanded);
    if (aceDiamond.isExpanded ||
        brickCard.isExpanded ||
        eightHearts.isExpanded ||
        twoClubs.isExpanded ||
        fourSpade.isExpanded) {
      if (aceDiamond.height < size[1] / 3) {
        brickCard.height += 1;
        brickCard.width += 1;
        brickCard.y = size[1] / 3;
        brickCard.x = size[0] / 5;

        eightHearts.height += 1;
        eightHearts.width += 1;
        eightHearts.y = size[1] / 3;
        eightHearts.x = size[0] / 3;

        twoClubs.height += 1;
        twoClubs.width += 1;
        twoClubs.y = size[1] / 3;
        twoClubs.x = size[0] / 2.15;

        fourSpade.height += 1;
        fourSpade.width += 1;
        fourSpade.y = size[1] / 3;
        fourSpade.x = size[0] / 1.67;

        aceDiamond.height += 1;
        aceDiamond.width += 1;
        aceDiamond.y = size[1] / 3;
        aceDiamond.x = size[0] / 1.36;

        cancelButton.y = size[1] - (cancelButton.height * 2);
        cancelButton.x = size[0] / 3;

        checkButton.y = size[1] - (checkButton.height * 2);
        checkButton.x = size[0] / 1.5;
      }

      if (brickCard.isBrickSelected) {
        brickCard.y = size[1] / 7;
      } else {
        brickCard.y = size[1] / 3;
      }

      if (eightHearts.isEightSelected) {
        eightHearts.y = size[1] / 7;
      } else {
        eightHearts.y = size[1] / 3;
      }

      if (twoClubs.isTwoSelected) {
        twoClubs.y = size[1] / 7;
      } else {
        twoClubs.y = size[1] / 3;
      }

      if (fourSpade.isFourSelected) {
        fourSpade.y = size[1] / 7;
      } else {
        fourSpade.y = size[1] / 3;
      }

      if (aceDiamond.isAceSelected) {
        aceDiamond.y = size[1] / 7;
      } else {
        aceDiamond.y = size[1] / 3;
      }
    }

    if (checkButton.isPressed) {
      //print(cardsSelected);
    }

    if (cancelButton.isPressed) {
      cancelButton.y = size[1];
      cancelButton.x = size[0];
      checkButton.y = size[1];
      checkButton.x = size[0];

      brickCard.y = size[1] - (cardHeight * 1.5);
      brickCard.x = size[0] / 2.2;
      brickCard.size = Vector2(cardWidth, cardHeight);
      //brickCard.isExpanded = false;

      eightHearts.y = size[1] - (cardHeight * 1.5);
      eightHearts.x = size[0] / 2.1;
      eightHearts.size = Vector2(cardWidth, cardHeight);
      //eightHearts.isExpanded = false;

      twoClubs.y = size[1] - (cardHeight * 1.5);
      twoClubs.x = size[0] / 2;
      twoClubs.size = Vector2(cardWidth, cardHeight);
      //twoClubs.isExpanded = false;

      fourSpade.y = size[1] - (cardHeight * 1.5);
      fourSpade.x = size[0] / 1.9;
      fourSpade.size = Vector2(cardWidth, cardHeight);
      //fourSpade.isExpanded = false;

      aceDiamond.y = size[1] - (cardHeight * 1.5);
      aceDiamond.x = size[0] / 1.8;
      aceDiamond.size = Vector2(cardWidth, cardHeight);
      //aceDiamond.isExpanded = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    sampleText.render(canvas, "Table 1", Vector2(size[0] / 2, 10));
  }
}

class ExitButton extends SpriteComponent with Tappable {
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      print("object");

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

class Cards extends SpriteComponent with Tappable {
  bool isExpanded = false;
  bool isSelected = false;
  bool isBrickSelected = false;
  bool isEightSelected = false;
  bool isTwoSelected = false;
  bool isFourSelected = false;
  bool isAceSelected = false;

  @override
  bool onTapDown(TapDownInfo info) {
    
      if (isBrickSelected) {
        isBrickSelected = false;
        cardsSelected.add("brick");
      } else {
        isBrickSelected = true;
        cardsSelected.remove("brick");
      }
      if (isEightSelected) {
        isEightSelected = false;
        cardsSelected.add("8_hearts");
      } else {
        isEightSelected = true;
        cardsSelected.remove("8_hearts");
      }
      if (isTwoSelected) {
        isTwoSelected = false;
        cardsSelected.add("2_clubs");
        
      } else {
        isTwoSelected = true;
        cardsSelected.remove("2_clubs");
      }
      if (isFourSelected) {
        isFourSelected = false;
        cardsSelected.add("4_spades");
      } else {
        isFourSelected = true;
        cardsSelected.remove("4_spades");
      }
      if (isAceSelected) {
        isAceSelected = false;
         cardsSelected.add("a_diamonds");
      } else {
        isAceSelected = true;
        cardsSelected.remove("a_diamonds");
      }
    
    

    isExpanded = true;
    return true;
  }
}

class CancelButton extends SpriteComponent with Tappable {
  bool isPressed = false;
  @override
  bool onTapDown(TapDownInfo info) {
    isPressed = true;
    return true;
  }
}

class CheckButton extends SpriteComponent with Tappable {
  bool isPressed = false;
  @override
  bool onTapDown(TapDownInfo info) {
    print(cardsSelected);
    isPressed = true;
    
    return true;
  }
}
