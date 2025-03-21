// File: card_widget.dart
import 'package:brick_hold_em/game/card_key.dart';
import 'package:brick_hold_em/providers/tapped_cards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_hold_em/providers/game_providers.dart'; // contains isPlayersTurnComputedProvider
import 'package:brick_hold_em/providers/hand_notifier.dart';   // contains handProvider

class CardWidget extends ConsumerWidget {
  final CardKey cardKey;
  /// Whether the card is already on the table.
  final bool isOnTable;
  
  const CardWidget({super.key, required this.cardKey, this.isOnTable = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build the card image.
    Widget cardImage = Image.asset(
      "assets/images/${cardKey.cardName}.png",
      width: 50,
      height: 70,
      fit: BoxFit.cover,
    );

    // If the card is in the hand (isOnTable == false), wrap it in a Hero.
    Widget displayedCard = isOnTable
        ? cardImage
        : Hero(tag: 'card_${cardKey.position}_${cardKey.cardName}', child: cardImage);

    return GestureDetector(
      onTap: () async {
        if (isOnTable) {
          // Untap: Remove from tapped cards and add back to hand.
          ref.read(tappedCardsProvider.notifier).removeCard(cardKey);
          ref.read(handProvider.notifier).addCard(cardKey);
          print("Untapped card: ${cardKey.cardName}");
        } else {
          // Tapping a card from the hand.
          if (ref.read(isPlayersTurnComputedProvider)) {
            print("Card tapped from hand: ${cardKey.cardName}");
            // For a brick card, show the brick selection modal.
            if (cardKey.cardName == 'brick') {
              await showModalBottomSheet(
                context: context,
                builder: (BuildContext ctx) {
                  return Consumer(builder: (context, ref, child) {
                    final currentSuit = ref.watch(brickCardSuitPositionProvider);
                    final currentNumber = ref.watch(brickCardNumberPositionProvider);
                    return Container(
                      color: Colors.white,
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Select Suit and Value",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 150,
                                  child: ListWheelScrollView(
                                    controller: FixedExtentScrollController(
                                        initialItem: currentSuit),
                                    itemExtent: 30,
                                    magnification: 1.8,
                                    useMagnifier: true,
                                    onSelectedItemChanged: (int value) {
                                      ref.read(brickCardSuitPositionProvider.notifier).state = value;
                                    },
                                    children: const [
                                      Text("Spade"),
                                      Text("Club"),
                                      Text("Heart"),
                                      Text("Diamond"),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 150,
                                  child: ListWheelScrollView(
                                    controller: FixedExtentScrollController(
                                        initialItem: currentNumber),
                                    itemExtent: 30,
                                    magnification: 1.8,
                                    useMagnifier: true,
                                    onSelectedItemChanged: (int value) {
                                      ref.read(brickCardNumberPositionProvider.notifier).state = value;
                                    },
                                    children: const [
                                      Text("Ace"),
                                      Text("2"),
                                      Text("3"),
                                      Text("4"),
                                      Text("5"),
                                      Text("6"),
                                      Text("7"),
                                      Text("8"),
                                      Text("9"),
                                      Text("10"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            child: const Text("Confirm"),
                            onPressed: () {
                              const suits = ['spades', 'clubs', 'hearts', 'diamonds'];
                              const numbers = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
                              final suit = ref.read(brickCardSuitPositionProvider);
                              final number = ref.read(brickCardNumberPositionProvider);
                              final newCardName = '${suits[suit]}${numbers[number]}';
                              final updatedCard = cardKey.copyWith(cardName: newCardName);
                              // Add the updated card to tapped cards.
                              ref.read(tappedCardsProvider.notifier).addCard(updatedCard);
                              // Remove the card from hand.
                              ref.read(handProvider.notifier).removeCard(cardKey);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  });
                },
              );
            } else {
              // For non-brick cards, add to tapped cards and remove from hand.
              ref.read(tappedCardsProvider.notifier).addCard(cardKey);
              ref.read(handProvider.notifier).removeCard(cardKey);
            }
          } else {
            print("Not your turn");
          }
        }
      },
      child: displayedCard,
    );
  }
}