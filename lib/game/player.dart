import 'dart:convert';

class Player {
  final String? name;
  final String username;
  final String photoUrl;
  final int? chips;
  final int? cardCount;
  final String uid;

  Player({
    this.name,
    required this.username,
    required this.photoUrl,
    this.chips,
    this.cardCount,
    required this.uid,
  });


  Player copyWith({
    String? name,
    String? username,
    String? photoUrl,
    int? chips,
    int? cardCount,
    String? uid,
  }) {
    return Player(
      name: name ?? this.name,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      chips: chips ?? this.chips,
      cardCount: cardCount ?? this.cardCount,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'photoUrl': photoUrl,
      'chips': chips,
      'cardCount': cardCount,
      'uid': uid,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Player(name: $name, username: $username, photoUrl: $photoUrl, chips: $chips, cardCount: $cardCount, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Player &&
      other.name == name &&
      other.username == username &&
      other.photoUrl == photoUrl &&
      other.chips == chips &&
      other.cardCount == cardCount &&
      other.uid == uid;
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'],
      username: map['username'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      chips: map['chips']?.toInt(),
      cardCount: map['cardCount']?.toInt(),
      uid: map['uid'] ?? '',
    );
  }

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source));

  @override
  int get hashCode {
    return name.hashCode ^
      username.hashCode ^
      photoUrl.hashCode ^
      chips.hashCode ^
      cardCount.hashCode ^
      uid.hashCode;
  }
}
