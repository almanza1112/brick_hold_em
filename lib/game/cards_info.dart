import 'package:flutter/material.dart';

@immutable
class CardsInfo {
  final List<int>? cardsSelected;

  const CardsInfo({
    this.cardsSelected
  });

  CardsInfo copyWith({
    List<int>? cardsSelected,
  }) {
    return CardsInfo(
      cardsSelected: cardsSelected ?? this.cardsSelected
    );
  }
}