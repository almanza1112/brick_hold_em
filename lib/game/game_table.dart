
import 'package:brick_hold_em/game/cards_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';


// TODO: need to do this
// Mario, one button to order/pair/color
// Bryant, one button to  expand to multiple buttons
// do both...

// Help button should be available only for non competive games

// Engine but do at end

List<String> cardsSelected = [];
List<String> cardsList = [];
List<Cards> cardsIntances = [];
List startingHand = [];
List<String> faceUpCardList = [];

var uid = FirebaseAuth.instance.currentUser!.uid;

SpriteComponent background = SpriteComponent();
Deck deck = Deck();
SpriteComponent faceUpCard = SpriteComponent();
SpriteComponent displayCard1 = SpriteComponent();
SpriteComponent displayCard2 = SpriteComponent();
SpriteComponent displayCard3 = SpriteComponent();
SpriteComponent displayCard4 = SpriteComponent();
List<SpriteComponent> displayCardsList =[];
SpriteComponent cardToPile = SpriteComponent();
late Cards player1card1;
late Cards player1card2;
late Cards player1card3;
late Cards player1card4;
late Cards player1card5;
late Cards player1card6;
late Cards player1card7;
late Cards player1card8;
late Cards player1card9;
late Cards player1card10;

PlayButton playButton = PlayButton();
const cardYPositionRow1 = 575.0;
const cardYPositionRow2 = 525.0;
late var sWidth;
late var sHeight;

class GameTable extends FlameGame with HasTappables {
    num? notchPadding;

  // TODO Need to redo on samsung devices.
  GameTable({this.notchPadding});


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

  //final double pokerCardHeight = 3.5;
  //final double pokerCardWidth = 2.5;
  //final double multiplier = 17;
  final double cardHeight = 3.5 * 20; //70
  final double cardWidth = 2.5 * 20; //50
  // Dimension of a poker card is 3.5 x 2.5 in, below the numebrs are multiplied by 17

  TextPaint sampleText = TextPaint(style: const TextStyle(fontSize: 18));


  @override
  Future<void> onLoad() async {
    super.onLoad();
    displayCardsList.add(displayCard1);
        displayCardsList.add(displayCard2);
    displayCardsList.add(displayCard3);
    displayCardsList.add(displayCard4);

    final screenWidth = size[0];
    final screenHeight = size[1] - notchPadding!;

    sWidth = screenWidth;
    sHeight = screenHeight;
    final cardDimensions = Vector2(cardWidth, cardHeight);

    var card1X = (screenWidth / 2) - ((cardWidth * 2.5) + 10); // 10 added at the end for padding
    var card2X = (screenWidth / 2) - ((cardWidth * 1.5) + 5); // 5 added at the end for padding
    var card3X = (screenWidth / 2) - (cardWidth / 2);
    var card4X = (screenWidth / 2) + ((cardWidth / 2) + 5);  // 5 added at the end for padding
    var card5X = (screenWidth / 2) + ((cardWidth * 1.5) + 10); // 10 added at the end for padding


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
    getFaceUpCard(screenHeight, screenWidth);
    if (snapshot.exists) {
      final _map = Map<String, dynamic>.from(snapshot.value as Map);

      // Get user's cards
      var myCards = _map[uid];
      startingHand = myCards['startingHand'];

      // Get face up card
      //var faceUpCardList = _map['faceUpCard'];

      List<dynamic> data = _map["dealer"];

      player1card1 = Cards(0)
        ..sprite = await loadSprite(startingHand[0] + '.png')
        ..size = cardDimensions
        ..y = cardYPositionRow1
        ..x = card1X;
      add(player1card1);

      player1card2 = Cards(1)
        ..sprite = await loadSprite(startingHand[1] + '.png')
        ..size = cardDimensions
        ..y = cardYPositionRow1
        ..x = card2X;
      add(player1card2);

      player1card3 = Cards(2)
        ..sprite = await loadSprite(startingHand[2] + '.png')
        ..size = cardDimensions
        ..y = cardYPositionRow1
        ..x = card3X;
      add(player1card3);

      player1card4 = Cards(3)
        ..sprite = await loadSprite(startingHand[3] + '.png')
        ..size = cardDimensions
        ..y = cardYPositionRow1
        ..x = card4X;
      add(player1card4);

      player1card5 = Cards(4)
        ..sprite = await loadSprite(startingHand[4] + '.png')
        ..size = cardDimensions
        ..y = cardYPositionRow1
        ..x = card5X;
      add(player1card5);

      cardsList.add(startingHand[0]);
      cardsList.add(startingHand[1]);
      cardsList.add(startingHand[2]);
      cardsList.add(startingHand[3]);
      cardsList.add(startingHand[4]);

      cardsIntances.add(player1card1);
      cardsIntances.add(player1card2);
      cardsIntances.add(player1card3);
      cardsIntances.add(player1card4);
      cardsIntances.add(player1card5);
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
      ..x = (screenWidth / 2) - (cardWidth / 2)
      ..y = (screenHeight / 2);
    add(deck);

    playButton
      ..sprite = await loadSprite('check.png')
      ..size = Vector2(40 , 40)
      ..x = (screenWidth / 2) - 20
      ..y = (screenHeight - 70);
    add(playButton);

  }

  @override
  void update(double dt) {
    super.update(dt);
    //var stop = ((size[1] - notchPadding!) / 2) - 100;
    var stop = -450;
    if(cardToPile.y > stop) {
      cardToPile.y -= 300 * dt;
    } else {
      cardToPile.removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //sampleText.render(canvas, "Table 1", Vector2(size[0] / 2, 10));
  }

  getFaceUpCard(double screenHeight, double screenWidth) async {
      DatabaseReference faceUpCardRef = FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');
      faceUpCardRef.onValue.listen((event) async { 
        var _faceUpCardList = List<String>.from(event.snapshot.value as List);
        faceUpCardList = _faceUpCardList;
        faceUpCard = SpriteComponent()
        ..sprite = await loadSprite('${_faceUpCardList[_faceUpCardList.length - 1]}.png')
        ..size = Vector2(cardWidth, cardHeight)
        ..y = (screenHeight / 2) - 100
        ..x = (screenWidth / 2) - (cardWidth + 5);
      add(faceUpCard);
      });
      
  }

}

class Cards extends SpriteComponent with Tappable {
  
  final int id;
  Cards(this.id);

  @override
  bool onTapDown(TapDownInfo info) {
    // Applying seleceting and unselecting of cards

    // unselecting cards
    if (cardsSelected.contains(cardsList[id])) {
      var index = cardsSelected.indexOf(cardsList[id]);
      cardsSelected.removeAt(index);
    } else {
      // selecting
      cardsSelected.add(cardsList[id]);
    }
    return true;
  }

}

// Hit Send and Check button
class Deck extends SpriteComponent with Tappable {
  
  @override
  bool onTapDown(TapDownInfo info) {
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

    // TODO: this is TEMP, need to optimize logic
    final sprite = await Sprite.load("$cardBeingAdded.png");
    final card = SpriteComponent(sprite: sprite, size:Vector2(2.5 * 20, 3.5 * 20) );

    card.position = Vector2(-140, 300);
    add(card);
  }
}

class PlayButton extends SpriteComponent with Tappable, HasGameRef<GameTable> {
  double get x => gameRef.size[0]; // width
  double get y => gameRef.size[1]; // height

   @override
  bool onTapDown(TapDownInfo info) {
    animateCard();
    play();
    return true;
  }

  animateCard() async {
    final sprite = await Sprite.load("backside.png");
     cardToPile = SpriteComponent(sprite: sprite, size: Vector2(2.5 * 20, 3.5 * 20));

    cardToPile.position = Vector2(0, -300);
    add(cardToPile);
  }

  play() async {
    final cardsRef = FirebaseDatabase.instance.ref('tables/1/cards');

    final faceUpCardListUpdate = [...faceUpCardList, ...cardsSelected];
    
    await cardsRef.update({
      "faceUpCard": faceUpCardListUpdate
    }).then((value) {
        addDisplayCards();
        //player1card1.removeFromParent();
        // Remove card sprites from game
        for (int i =0; i < cardsSelected.length; i++) {
          
        }
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  addDisplayCards() async {
    var cardsSelectedReversed =  List.from(cardsSelected.reversed);
    cardsSelectedReversed.removeAt(0);
    for (int i = 0; i < cardsSelectedReversed.length; i++) {
          final sprite = await Sprite.load("${cardsSelectedReversed[i]}.png");
          displayCardsList[i] = SpriteComponent(sprite: sprite, size: Vector2(2.5 * 20, 3.5 * 20));
          double x = (i * -50) -60;
          displayCardsList[i].position = Vector2(x, -477);
          add(displayCardsList[i]);

    }
  }
}

class MyScrollableRow extends StatelessWidget {
  const MyScrollableRow({super.key});

   @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: 150,
      height: 100,
      child: Text("data"),
    );
  }
}
