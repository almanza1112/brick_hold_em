import 'dart:developer';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'dart:convert';

// TODO: need to do this
// Mario, one button to order/pair/color
// Bryant, one button to  expand to multiple buttons
// do both...

// Help button should be available only for non competive games

// Engine but do at end

List<String> cardsSelected = [];
var uid = FirebaseAuth.instance.currentUser!.uid;


class GameTable extends FlameGame with HasTappables {
  GameTable({required this.notchPadding});

  num notchPadding;

  SpriteComponent background = SpriteComponent();
  Deck deck = Deck();
  SpriteComponent faceUpCard = SpriteComponent();
  late Cards player1card1;
  late Cards player1card2;
  late Cards player1card3;
  late Cards player1card4;
  late Cards player1card5;

  // User is Player 1, going counter clockwise players are numbered
  // Player 2
  // SpriteComponent player2Card1 = SpriteComponent();
  // SpriteComponent player2Card2 = SpriteComponent();
  // SpriteComponent player2Card3 = SpriteComponent();
  // SpriteComponent player2Card4 = SpriteComponent();
  // // Player 3
  // SpriteComponent player3Card1 = SpriteComponent();
  // SpriteComponent player3Card2 = SpriteComponent();
  // SpriteComponent player3Card3 = SpriteComponent();
  // SpriteComponent player3Card4 = SpriteComponent();
  // // Player 4
  // SpriteComponent player4Card1 = SpriteComponent();
  // SpriteComponent player4Card2 = SpriteComponent();
  // SpriteComponent player4Card3 = SpriteComponent();
  // SpriteComponent player4Card4 = SpriteComponent();
  // // Player 5
  // SpriteComponent player5Card1 = SpriteComponent();
  // SpriteComponent player5Card2 = SpriteComponent();
  // SpriteComponent player5Card3 = SpriteComponent();
  // SpriteComponent player5Card4 = SpriteComponent();

  CancelButton cancelButton = CancelButton();
  CheckButton checkButton = CheckButton();
  final Vector2 exitButtonSize = Vector2(50.0, 30.0);

  //final double pokerCardHeight = 3.5;
  //final double pokerCardWidth = 2.5;
  //final double multiplier = 17;
  final double cardHeight = 3.5 * 17; //59.5
  final double cardWidth = 2.5 * 17; //42.5
  // Dimension of a poker card is 3.5 x 2.5 in, below the numebrs are multiplied by 17
  final cardDimensions = Vector2(42.5, 59.5);

  TextPaint sampleText = TextPaint(style: const TextStyle(fontSize: 18));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1] - notchPadding;

    var card1X = (screenWidth / 2) - ((cardWidth * 2.5) + 10); // 10 added at the end for padding
    var card2X = (screenWidth / 2) - ((cardWidth * 1.5) + 5); // 5 added at the end for padding
    var card3X = (screenWidth / 2) - (cardWidth / 2);
    var card4X = (screenWidth / 2) + ((cardWidth / 2) + 5);  // 5 added at the end for padding
    var card5X = (screenWidth / 2) + ((cardWidth * 1.5) + 10); // 10 added at the end for padding

    const cardYPosition = 650.0;


    DatabaseReference database = FirebaseDatabase.instance.ref('tables/1');
    DatabaseReference dealtCards =
        FirebaseDatabase.instance.ref('tables/1/cards');

    // adding user to table
    await database.update({
      "players/$uid/name": FirebaseAuth.instance.currentUser!.displayName,
      "players/$uid/photoURL": FirebaseAuth.instance.currentUser!.photoURL
    });

    // Listening for any changes
    database.onValue.listen((event) {
      final data = event.snapshot.value;
      //print(data);
    });

    final onceRef = FirebaseDatabase.instance.ref();
    final snapshot = await onceRef.child('tables/1/cards').get();
    if (snapshot.exists) {
      final _map = Map<String, dynamic>.from(snapshot.value as Map);

      // Get user's cards
      var myCards = _map[uid];
      var startingHand = myCards['startingHand'];

      // Get face up card
      var faceUpCardList = _map['faceUpCard'];

      List<dynamic> data = _map["dealer"];

      faceUpCard = SpriteComponent()
        ..sprite = await loadSprite(faceUpCardList[0] + '.png')
        ..size = cardDimensions
        ..y = (screenHeight / 2) - 100
        ..x = (screenWidth / 2) - (cardWidth + 5);
      add(faceUpCard);

      player1card1 = Cards()
        ..sprite = await loadSprite(startingHand[0] + '.png')
        ..size = cardDimensions
        ..y = cardYPosition
        ..x = card1X;
      add(player1card1);

      player1card2 = Cards()
        ..sprite = await loadSprite(startingHand[1] + '.png')
        ..size = cardDimensions
        ..y = cardYPosition
        ..x = card2X;
      add(player1card2);

      player1card3 = Cards()
        ..sprite = await loadSprite(startingHand[2] + '.png')
        ..size = cardDimensions
        ..y = cardYPosition
        ..x = card3X;
      add(player1card3);

      player1card4 = Cards()
        ..sprite = await loadSprite(startingHand[3] + '.png')
        ..size = cardDimensions
        ..y = cardYPosition
        ..x = card4X;
      add(player1card4);

      player1card5 = Cards()
        ..sprite = await loadSprite(startingHand[4] + '.png')
        ..size = cardDimensions
        ..y = cardYPosition
        ..x = card5X;
      add(player1card5);
    }

    dealtCards.onValue.listen((event) async {
      final _map = Map<String, dynamic>.from(event.snapshot.value as Map);
      List<dynamic> data = _map["dealer"];
    });

    // add(background
    //   ..sprite = await loadSprite('table.png')
    //   ..y = screenHeight / 2.5
    //   ..size = Vector2(size[0], 250));

    deck
      ..sprite = await loadSprite('backside.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..x = (screenWidth / 2) + 5
      ..y = (screenHeight / 2) - 100;
    add(deck);

    

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

    if (player1card1.isExpanded ||
        player1card2.isExpanded ||
        player1card3.isExpanded ||
        player1card4.isExpanded ||
        player1card5.isExpanded) {
      if (player1card1.height < 80) {
        player1card2.height += 1;
        player1card2.width += 1;
        player1card2.y = size[1] / 3;
        player1card2.x = size[0] / 5;

        player1card3.height += 1;
        player1card3.width += 1;
        player1card3.y = size[1] / 3;
        player1card3.x = size[0] / 3;

        player1card4.height += 1;
        player1card4.width += 1;
        player1card4.y = size[1] / 3;
        player1card4.x = size[0] / 2.15;

        player1card5.height += 1;
        player1card5.width += 1;
        player1card5.y = size[1] / 3;
        player1card5.x = size[0] / 1.67;

        player1card1.height += 1;
        player1card1.width += 1;
        player1card1.y = size[1] / 3;
        player1card1.x = size[0] / 1.36;

        cancelButton.y = size[1] - (cancelButton.height * 2);
        cancelButton.x = size[0] / 3;

        checkButton.y = size[1] - (checkButton.height * 2);
        checkButton.x = size[0] / 1.5;
      }

      if (player1card2.isBrickSelected) {
        player1card2.y = size[1] / 7;
      } else {
        player1card2.y = size[1] / 3;
      }

      if (player1card3.isEightSelected) {
        player1card3.y = size[1] / 7;
      } else {
        player1card3.y = size[1] / 3;
      }

      if (player1card4.isTwoSelected) {
        player1card4.y = size[1] / 7;
      } else {
        player1card4.y = size[1] / 3;
      }

      if (player1card5.isFourSelected) {
        player1card5.y = size[1] / 7;
      } else {
        player1card5.y = size[1] / 3;
      }

      if (player1card1.isAceSelected) {
        player1card1.y = size[1] / 7;
      } else {
        player1card1.y = size[1] / 3;
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

      player1card2.y = size[1] - (cardHeight * 1.5);
      player1card2.x = size[0] / 2.2;
      //player1card2.size = Vector2(cardWidth, cardHeight);
      //brickCard.isExpanded = false;

      player1card3.y = size[1] - (cardHeight * 1.5);
      player1card3.x = size[0] / 2.1;
      //player1card3.size = Vector2(cardWidth, cardHeight);
      //eightHearts.isExpanded = false;

      player1card4.y = size[1] - (cardHeight * 1.5);
      player1card4.x = size[0] / 2;
      //player1card4.size = Vector2(cardWidth, cardHeight);
      //twoClubs.isExpanded = false;

      player1card5.y = size[1] - (cardHeight * 1.5);
      player1card5.x = size[0] / 1.9;
      //player1card5.size = Vector2(cardWidth, cardHeight);
      //fourSpade.isExpanded = false;

      player1card1.y = size[1] - (cardHeight * 1.5);
      player1card1.x = size[0] / 1.8;
      //player1card1.size = Vector2(cardWidth, cardHeight);
      //aceDiamond.isExpanded = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //sampleText.render(canvas, "Table 1", Vector2(size[0] / 2, 10));
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

class Deck extends SpriteComponent with Tappable {
  @override
  bool onTapDown(TapDownInfo info) {
    print("hitting");
    doThis();
    return true;
  }

  doThis() async {
    final dealerRef = FirebaseDatabase.instance.ref('tables/1/cards/dealer');
    final playersCardsRef = FirebaseDatabase.instance.ref('tables/1/cards/$uid/startingHand');
    final cardsRef = FirebaseDatabase.instance.ref('tables/1/cards');
    final event = await dealerRef.once();
    final playerEvent = await playersCardsRef.once();

    var deck = List<String>.from(event.snapshot.value as List);
    var playersCards = List<String>.from(playerEvent.snapshot.value as List);

    var cardBeingAdded = deck[deck.length -1];
    playersCards.add(cardBeingAdded);
    deck.removeLast();

    await cardsRef.update({
      "dealer" : deck,
      "$uid/startingHand" : playersCards
    });

    Image newCard = Image.asset(cardBeingAdded + ".png");
    final sprite = await Sprite.load(cardBeingAdded + ".png");
    final card = SpriteComponent(sprite: sprite, size:Vector2(42.5, 59.5) );

    card.position = Vector2(100, 100);
    add(card);
    
  }
}
