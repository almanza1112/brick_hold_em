// File: tapped_cards_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_hold_em/game/card_key.dart';

class TappedCardsNotifier extends StateNotifier<List<CardKey>> {
  TappedCardsNotifier() : super([]);
  void addCard(CardKey card) {
    state = [...state, card];
  }

  void removeCard(CardKey card) {
    final newList = List<CardKey>.from(state);
    newList.removeWhere((element) => element == card);
    state = newList;
  }

  void removeCardAt(int index) {
    final newList = List<CardKey>.from(state);
    newList.removeAt(index);
    state = newList;
  }
  
  void clear() {
    state = [];
  }
}
final tappedCardsProvider =
    StateNotifierProvider<TappedCardsNotifier, List<CardKey>>(
        (ref) => TappedCardsNotifier());