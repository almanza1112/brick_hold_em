class CardRules {
  List<String> cards;
  CardRules({required this.cards});

  var cardInfo = {
    'diamond2': {'value': 2, 'color': 'blue', 'suit': 'diamond'},
    'diamond3': {'value': 3, 'color': 'blue', 'suit': 'diamond'},
    'diamond4': {'value': 4, 'color': 'blue', 'suit': 'diamond'},
    'diamond5': {'value': 5, 'color': 'blue', 'suit': 'diamond'},
    'diamond6': {'value': 6, 'color': 'blue', 'suit': 'diamond'},
    'diamond7': {'value': 7, 'color': 'blue', 'suit': 'diamond'},
    'diamond8': {'value': 8, 'color': 'blue', 'suit': 'diamond'},
    'diamond9': {'value': 9, 'color': 'blue', 'suit': 'diamond'},
    'diamond10': {'value': 10, 'color': 'blue', 'suit': 'diamond'},
    'diamondAce': {'value': 1, 'color': 'blue', 'suit': 'diamond'},
    'club2': {'value': 2, 'color': 'green', 'suit': 'club'},
    'club3': {'value': 3, 'color': 'green', 'suit': 'club'},
    'club4': {'value': 4, 'color': 'green', 'suit': 'club'},
    'club5': {'value': 5, 'color': 'green', 'suit': 'club'},
    'club6': {'value': 6, 'color': 'green', 'suit': 'club'},
    'club7': {'value': 7, 'color': 'green', 'suit': 'club'},
    'club8': {'value': 8, 'color': 'green', 'suit': 'club'},
    'club9': {'value': 9, 'color': 'green', 'suit': 'club'},
    'club10': {'value': 10, 'color': 'green', 'suit': 'club'},
    'clubAce': {'value': 1, 'color': 'green', 'suit': 'club'},
    'hearts2': {'value': 2, 'color': 'red', 'suit': 'hearts'},
    'hearts3': {'value': 3, 'color': 'red', 'suit': 'hearts'},
    'hearts4': {'value': 4, 'color': 'red', 'suit': 'hearts'},
    'hearts5': {'value': 5, 'color': 'red', 'suit': 'hearts'},
    'hearts6': {'value': 6, 'color': 'red', 'suit': 'hearts'},
    'hearts7': {'value': 7, 'color': 'red', 'suit': 'hearts'},
    'hearts8': {'value': 8, 'color': 'red', 'suit': 'hearts'},
    'hearts9': {'value': 9, 'color': 'red', 'suit': 'hearts'},
    'hearts10': {'value': 10, 'color': 'red', 'suit': 'hearts'},
    'heartsAce': {'value': 1, 'color': 'red', 'suit': 'hearts'},
    'spade2': {'value': 2, 'color': 'black', 'suit': 'spade'},
    'spade3': {'value': 3, 'color': 'black', 'suit': 'spade'},
    'spade4': {'value': 4, 'color': 'black', 'suit': 'spade'},
    'spade5': {'value': 5, 'color': 'black', 'suit': 'spade'},
    'spade6': {'value': 6, 'color': 'black', 'suit': 'spade'},
    'spade7': {'value': 7, 'color': 'black', 'suit': 'spade'},
    'spade8': {'value': 8, 'color': 'black', 'suit': 'spade'},
    'spade9': {'value': 9, 'color': 'black', 'suit': 'spade'},
    'spade10': {'value': 10, 'color': 'black', 'suit': 'spade'},
    'spadeAce': {'value': 1, 'color': 'black', 'suit': 'spade'},
    'brick': {'value': 'brick', 'color': 'brick', 'suit': 'brick'}
  };

  String play() {
    print(cards);
    switch (cards.length) {
      case 2:
        return _playForTwoCards();
      case 3:
        return _playForThreeCards();
      case 4:
        return _playForFourCards();
      case 5:
        return _playForFiveCards();
      default:
        return 'else';
    }
  }

  String _playForTwoCards() {
    var card1 = cardInfo[cards[0]] as Map<String, dynamic>;
    var card2 = cardInfo[cards[1]] as Map<String, dynamic>;

    if (card1['value'] == 'brick' || card2['value'] == 'brick') {
      return 'success';
    } else if (card1['value'] == card2['value'] ||
        card1['color'] == card2['color']) {
      return 'success';
    } else {
      return 'invalid card combo';
    }
  }

  String _playForThreeCards() {
    // ONE PAIR: with 1st + 2nd card having the same suit, 2nd + 3rd must be the same
    // THREE OF A KIND: all three are the same
    var card1 = cardInfo[cards[0]] as Map<String, dynamic>;
    var card2 = cardInfo[cards[1]] as Map<String, dynamic>;
    var card3 = cardInfo[cards[2]] as Map<String, dynamic>;

    if (card1['value'] == card2['value'] && card2['value'] == card3['value']) {
      // Three of a kind
      return 'success';
    } else if (card1['color'] == card2['color'] &&
        card2['value'] == card3['value']) {
      return 'success';
    } else {
      return 'invalid card combo';
    }
  }

  String _playForFourCards() {
    // THREE OF A KIND: cards 1 + 2 have to have same color, 2-4 must all be the same
    // FOUR OF A KIND: all cards must have the same value
    // TWO PAIR: cards 1 + 2 must have same value, 2 + 3 same color, 3 + 4 same value
    var card1 = cardInfo[cards[0]] as Map<String, dynamic>;
    var card2 = cardInfo[cards[1]] as Map<String, dynamic>;
    var card3 = cardInfo[cards[2]] as Map<String, dynamic>;
    var card4 = cardInfo[cards[3]] as Map<String, dynamic>;

    if (card1['color'] == card2['color'] &&
        card2['value'] == card3['value'] &&
        card3['value'] == card4['value'] &&
        card2['value'] == card4['value']) {
      // three of a kind
      return 'success';
    } else if (card1['value'] == card2['value'] &&
        card2['value'] == card3['value'] &&
        card3['value'] == card4['value'] &&
        card2['value'] == card4['value']) {
      // four of a kind
      return 'success';
    } else if (card1['value'] == card2['value'] &&
        card2['color'] == card3['color'] &&
        card3['value'] == card4['value']) {
      // two pair
      return 'success';
    } else {
      return 'invalid card combo';
    }
  }

  String _playForFiveCards() {
    // STRAIGHT: ace can be connected from 10 to 2, so 9, 10, A (1) , 2, 3 counts
    // FLUSH: all cards are the same color/suit
    // FOUR OF A KIND: cards 1 + 2 must be same color/cuit, 2-5 must have same value
    // FULL HOUSE: one pair + three of a kind

    var card1 = cardInfo[cards[0]] as Map<String, dynamic>;
    var card2 = cardInfo[cards[1]] as Map<String, dynamic>;
    var card3 = cardInfo[cards[2]] as Map<String, dynamic>;
    var card4 = cardInfo[cards[3]] as Map<String, dynamic>;
    var card5 = cardInfo[cards[4]] as Map<String, dynamic>;

    if (card1['suit'] == card2['suit'] &&
        card2['suit'] == card3['suit'] &&
        card3['suit'] == card4['suit'] &&
        card4['suit'] == card5['suit']) {
      // flush
      return 'success';
    } else if (card1['color'] == card2['color'] &&
        card2['value'] == card3['value'] &&
        card3['value'] == card4['value'] &&
        card4['value'] == card5['value']) {
      // four of a kind
      return 'success';
    } else if (card1['value'] == card2['value'] &&
        card2['color'] == card3['color'] &&
        card3['value'] == card4['value'] &&
        card4['value'] == card5['value']) {
      // full house
      return 'success';
    } else if (card1['value'] == card2['value'] &&
        card2['value'] == card3['value'] &&
        card3['color'] == card4['color'] &&
        card4['value'] == card5['value']) {
      // full house
      return 'success';
    } else {
      
      List<int> cardValues = [
        card1['value'],
        card2['value'],
        card3['value'],
        card4['value'],
        card5['value']
      ];

      cardValues.sort();
      print(cardValues);

      final ifThereIsAnAce = cardValues.indexWhere((num)=> num == 1);
      print(ifThereIsAnAce);
      if (ifThereIsAnAce == -1) {
        // There isnt an ace, proceed to see for regular straight
        for (int i = 1; i < cardValues.length; i++) {
          if (cardValues[i] != cardValues[i - 1] + 1) {
            return "invalid card combo";
          }
        }
        return 'success';
      } else {
       print("elseeee");


       if (cardValues[4] == 5){
        // A, 2, 3, 4 ,5
         for (int i = 1; i < cardValues.length; i++) {
            if (cardValues[i] != cardValues[i - 1] + 1) {
              return "invalid card combo";
            }
          }
          return 'success';
       } else if (cardValues[4] == 10) {
        // A, 7, 8, 9, 10

       }
        return 'invalid card combo'; // There is an ace
      }
    }
  }
}
