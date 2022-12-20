import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<String> cardsSelected = [];

class GameTable extends FlameGame with HasTappables {

  GameTable({required this.notchPadding});
    
  num notchPadding;

  SpriteComponent background = SpriteComponent();
  late Cards player1card1;
  late Cards player1card2;
  late Cards player1card3;
  late Cards player1card4;
  late Cards player1card5;

  Dealer dealer = Dealer();
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

  final double cardHeight = 40.0;
  final double cardWidth = 25.0;

  TextPaint sampleText = TextPaint(style: const TextStyle(fontSize: 18));

  // void fetchCards() async {
  //   http.Response response = await http
  //       .get(Uri.parse('https://brick-hold-em-api.herokuapp.com/table'));

  //   Map data = jsonDecode(response.body);

  //   print(cardSetter.setCard(data));
  // }


  @override
  Future<void> onLoad() async {
    super.onLoad();
      var uid = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference database = FirebaseDatabase.instance.ref('tables/1');
      await database.update({
        "players/$uid/name": FirebaseAuth.instance.currentUser!.displayName,
        "players/$uid/photoURL": FirebaseAuth.instance.currentUser!.photoURL
      });
      database.onValue.listen((event) {
        final data = event.snapshot.value;
        print(data);
      });

    http.Response response = await http
        .get(Uri.parse('https://brick-hold-em-api.onrender.com/table'));

    Map data = jsonDecode(response.body);

    List startingHand = CardSetter().setCard(data);

    final screenWidth = size[0] - notchPadding;
    final screenHeight = size[1];

    add(background
      ..sprite = await loadSprite('background.webp')
      ..size = size);

    dealer
      ..sprite = await loadSprite('dealer.png')
      ..size = Vector2(60, 60)
      ..x = (screenWidth / 2)
      ..y = 10;
    add(dealer);

    // PLAYER 1
    player1card1 = Cards()
      ..sprite = await loadSprite(startingHand[0])
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 2.2;
    add(player1card1);

    player1card2 = Cards()
      ..sprite = await loadSprite(startingHand[1])
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 2.1;
    add(player1card2);

    player1card3 = Cards()
      ..sprite = await loadSprite(startingHand[2])
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 2;
    add(player1card3);

    player1card4 = Cards()
      ..sprite = await loadSprite(startingHand[3])
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 1.9;
    add(player1card4);

    player1card5 = Cards()
      ..sprite = await loadSprite(startingHand[4])
      ..size = Vector2(cardWidth, cardHeight)
      ..y = screenHeight - (cardHeight * 1.5)
      ..x = screenWidth / 1.8;
    add(player1card5);

    // PLAYER 2
    // player2Card1
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight - 60
    //   ..x = screenWidth - 200
    //   ..angle = radians(315);
    // add(player2Card1);

    // player2Card2
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.1
    //   ..x = cardWidth
    //   ..angle = radians(315);
    // add(player2Card2);

    // player2Card3
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2
    //   ..x = cardWidth
    //   ..angle = radians(315);
    // add(player2Card3);

    // player2Card4
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 1.9
    //   ..x = cardWidth
    //   ..angle = radians(315);
    // add(player2Card4);

    // // Player 3
    // player3Card1
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 1.8
    //   ..x = cardWidth
    //   ..angle = radians(270);
    // add(player3Card1);

    // player3Card2
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.5
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player3Card2);

    // player3Card3
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.4
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player3Card3);

    // player3Card4
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.3
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player3Card4);

    // // Player 4
    // player4Card1
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.2
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player4Card1);

    // player4Card2
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.1
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player4Card2);

    // player4Card3
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.2
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player4Card3);

    // player4Card4
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.1
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player4Card4);

    // // Player 5
    // player5Card1
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.2
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player5Card1);

    // player5Card2
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.1
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player5Card2);

    // player5Card3
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.2
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player5Card3);

    // player5Card4
    //   ..sprite = await loadSprite('backside.png')
    //   ..size = Vector2(cardWidth, cardHeight)
    //   ..y = screenHeight / 2.1
    //   ..x = screenWidth - cardWidth
    //   ..angle = radians(90);
    // add(player5Card4);

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
      player1card2.size = Vector2(cardWidth, cardHeight);
      //brickCard.isExpanded = false;

      player1card3.y = size[1] - (cardHeight * 1.5);
      player1card3.x = size[0] / 2.1;
      player1card3.size = Vector2(cardWidth, cardHeight);
      //eightHearts.isExpanded = false;

      player1card4.y = size[1] - (cardHeight * 1.5);
      player1card4.x = size[0] / 2;
      player1card4.size = Vector2(cardWidth, cardHeight);
      //twoClubs.isExpanded = false;

      player1card5.y = size[1] - (cardHeight * 1.5);
      player1card5.x = size[0] / 1.9;
      player1card5.size = Vector2(cardWidth, cardHeight);
      //fourSpade.isExpanded = false;

      player1card1.y = size[1] - (cardHeight * 1.5);
      player1card1.x = size[0] / 1.8;
      player1card1.size = Vector2(cardWidth, cardHeight);
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

class Dealer extends SpriteComponent with Tappable {
  static List deck = ([]);
  @override
  bool onTapDown(TapDownInfo info) {
    print(deck[0]);
    return true;
  }
}

class CardSetter {
  List restOfTheDeck = ([]);
  List cardList = ([]);


  List setCard(Map map) {
    cardList = map['cards'];
    List startingHand = ([]);

    for(var i = 0; i < 5; i++){
      startingHand.add(cardList[i]+'.png');
      cardList.remove(i);
    }

    setDeck(cardList);
    print(cardList);
    return startingHand;
  }

  void setDeck(List restOfTheDeck){
    Dealer.deck = restOfTheDeck;

  }

  drawCard(){
            print(cardList);

    var cardDrawn = cardList[0];
    cardList.remove(0);

    return cardDrawn;
  }
}
