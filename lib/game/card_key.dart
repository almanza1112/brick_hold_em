class CardKey {
  int? position;
  String? cardName;
  bool? isBrick;

  CardKey({required this.position, required this.cardName, required this.isBrick});

  CardKey copyWith({int? position, String? cardName}) {
    return CardKey(
      position: position ?? this.position,
      cardName: cardName ?? this.cardName,
      isBrick: isBrick,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardKey &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          cardName == other.cardName &&
          isBrick == other.isBrick;

  @override
  int get hashCode => position.hashCode ^ cardName.hashCode ^ isBrick.hashCode;

  @override
  String toString() => 'CardKey(position: $position, cardName: $cardName)';
}