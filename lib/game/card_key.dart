class CardKey {
  int? position;
  String? cardName;
  bool? isBrick;

  CardKey(
      {required this.position, required this.cardName, required this.isBrick});

  CardKey copyWith({int? position, String? cardName}) {
    return CardKey(
        position: position ?? this.position,
        cardName: cardName ?? this.cardName,
        isBrick: isBrick ?? this.isBrick);
  }

  @override
  String toString() =>
      'CardKeys(position: $position, cardName: $cardName)';
}
