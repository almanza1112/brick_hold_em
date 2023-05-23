
import 'package:flutter/cupertino.dart';

class CardKey {
  int? position;
  String? cardName;
  Matrix4? cardXY;

  CardKey(
      {required this.position, required this.cardName, this.cardXY});

  CardKey copyWith({int? position, String? cardName, Matrix4? cardXY}) {
    return CardKey(
        position: position ?? this.position,
        cardName: cardName ?? this.cardName,
        cardXY: cardXY ?? this.cardXY);
  }

  @override
  String toString() =>
      'CardKeys(position: $position, cardName: $cardName, cardXY: $cardXY)';
}
