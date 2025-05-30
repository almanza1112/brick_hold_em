import 'cards_info.dart';

class CardRules {
  List<String> cards;
  CardRules({required this.cards});
  String success = 'success';
  String invalidCardCombo = 'invalid card combo';

  Map<String, dynamic> play() {
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
        return {};
    }
  }

  Map<String, dynamic> _playForTwoCards() {
    // COMBOS THAT CAN BE PLAYED...
    // SINGLE - NUMBER 1st & 2nd card are the same value
    // SINGLE - SUIT: 1st & 2nd card are the same color
    var card1 = cardInfo[cards[0]] as Map<String, dynamic>;
    var card2 = cardInfo[cards[1]] as Map<String, dynamic>;

    if (card1['value'] == card2['value'] ||
        card1['color'] == card2['color'] ||
        card2['value'] > card1['value']) {
      // Single Number or Suit
      return {"success": true, "anteMultiplier": 0};
    } else {
      // There was no valid combo
      return {"success": false};
    }
  }

  Map<String, dynamic> _playForThreeCards() {
    // COMBOS THAT CAN BE PLAYED...
    // ONE PAIR: with 1st + 2nd card having the same suit/color, 2nd + 3rd must be the same number
    // THREE OF A KIND: all three are the same number
    print(cards);
    var card1 = cardInfo[cards[0]] as Map<String, dynamic>;
    var card2 = cardInfo[cards[1]] as Map<String, dynamic>;
    var card3 = cardInfo[cards[2]] as Map<String, dynamic>;

    if (card1['value'] == card2['value'] && card2['value'] == card3['value']) {
      // Three of a Kind: all 3 are same value
      return {"success": true, "anteMultiplier": 1};
    } else if (card1['color'] == card2['color'] &&
        card2['value'] == card3['value']) {
      // One Pair: 1st and 2nd card are the same color/suit, 2nd and 3rd are the same value
      return {"success": true, "anteMultiplier": 1};
    } else {
      // There was no valid combo
      return {"success": false};
    }
  }

  Map<String, dynamic> _playForFourCards() {
    // COMBOS THAT CAN BE PLAYED...
    // THREE OF A KIND: cards 1 + 2 have to have same color, 2-4 must all be the same
    // FOUR OF A KIND: all cards must have the same value
    // TWO PAIR: cards 1 + 2 must have same value, 2 + 3 same color, 3 + 4 same value
    var card1 = cardInfo[cards[0]] as Map<String, dynamic>;
    var card2 = cardInfo[cards[1]] as Map<String, dynamic>;
    var card3 = cardInfo[cards[2]] as Map<String, dynamic>;
    var card4 = cardInfo[cards[3]] as Map<String, dynamic>;

    // There is no brick card
    if (card1['color'] == card2['color'] &&
        card2['value'] == card3['value'] &&
        card3['value'] == card4['value'] &&
        card2['value'] == card4['value']) {
      // Three of a Kind: 1st & 2nd card are the same color/suit. 2nd, 3rd, 4th
      // are all the same value
      return {"success": true, "anteMultiplier": 1};
    } else if (card1['value'] == card2['value'] &&
        card2['value'] == card3['value'] &&
        card3['value'] == card4['value'] &&
        card2['value'] == card4['value']) {
      // Four of a Kind: all cards are the same value
      return {"success": true, "anteMultiplier": 4};
    } else if (card1['value'] == card2['value'] &&
        card2['color'] == card3['color'] &&
        card3['value'] == card4['value']) {
      // Two Pair: 1st & 2nd cards have same value, 2nd & 3rd same color/suit, 3rd & 4th same value
      return {"success": true, "anteMultiplier": 1};
    } else {
      // There is no valid combo
      return {"success": false};
    }
  }

  Map<String, dynamic> _playForFiveCards() {
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
      // Flush
      return {"success": true, "anteMultiplier": 2};
    } else if (card1['color'] == card2['color'] &&
        card2['value'] == card3['value'] &&
        card3['value'] == card4['value'] &&
        card4['value'] == card5['value']) {
      // Four of a Kind
      return {"success": true, "anteMultiplier": 4};
    } else if (card1['value'] == card2['value'] &&
        card2['color'] == card3['color'] &&
        card3['value'] == card4['value'] &&
        card4['value'] == card5['value']) {
      // Full House
      return {"success": true, "anteMultiplier": 2};
    } else if (card1['value'] == card2['value'] &&
        card2['value'] == card3['value'] &&
        card3['color'] == card4['color'] &&
        card4['value'] == card5['value']) {
      // full house
      return {"success": true, "anteMultiplier": 2};
    } else {
      // Create list of cardValues to determine Straight
      List<int> cardValues = [
        card1['value'],
        card2['value'],
        card3['value'],
        card4['value'],
        card5['value']
      ];

      // Sort the list
      cardValues.sort();

      // Check if there is an Ace(1) among the cards
      final ifThereIsAnAce = cardValues.indexWhere((e) => e == 1);

      if (ifThereIsAnAce == -1) {
        // There isnt an ace, proceed to see for regular straight
        for (int i = 1; i < cardValues.length; i++) {
          if (cardValues[i] != cardValues[i - 1] + 1) {
            return {"success": false};
          }
        }
        return {"success": true, "anteMultiplier": 2};
      } else {
        // There is an Ace, all variations of Ace being a bridge
        if (cardValues[0] == 1 &&
            cardValues[1] == 7 &&
            cardValues[2] == 8 &&
            cardValues[3] == 9 &&
            cardValues[4] == 10) {
          return {"success": true, "anteMultiplier": 2};
        } else if (cardValues[0] == 1 &&
            cardValues[1] == 2 &&
            cardValues[2] == 8 &&
            cardValues[3] == 9 &&
            cardValues[4] == 10) {
          return {"success": true, "anteMultiplier": 2};
        } else if (cardValues[0] == 1 &&
            cardValues[1] == 2 &&
            cardValues[2] == 3 &&
            cardValues[3] == 9 &&
            cardValues[4] == 10) {
          return {"success": true, "anteMultiplier": 2};
        } else if (cardValues[0] == 1 &&
            cardValues[1] == 2 &&
            cardValues[2] == 3 &&
            cardValues[3] == 4 &&
            cardValues[4] == 10) {
          return {"success": true, "anteMultiplier": 2};
        } else if (cardValues[0] == 1 &&
            cardValues[1] == 2 &&
            cardValues[2] == 3 &&
            cardValues[3] == 4 &&
            cardValues[4] == 5) {
          return {"success": true, "anteMultiplier": 2};
        } else {
          return {"success": false};
        }
      }
    }
  }
}
