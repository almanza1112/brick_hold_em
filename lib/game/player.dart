import 'dart:convert';

class Player {
  final String? name;
  final String username;
  final String photoURL;
  final String? fullName;
  final int? chips;
  final int? cardCount;
  final String uid;

  Player({
    this.name,
    required this.username,
    required this.photoURL,
    this.fullName,
    this.chips,
    this.cardCount,
    required this.uid,
  });


  Player copyWith({
    String? name,
    String? username,
    String? photoURL,
    String? fullName,
    int? chips,
    int? cardCount,
    String? uid,
  }) {
    return Player(
      name: name ?? this.name,
      username: username ?? this.username,
      photoURL: photoURL ?? this.photoURL,
      fullName: fullName ?? this.fullName,
      chips: chips ?? this.chips,
      cardCount: cardCount ?? this.cardCount,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'photoURL': photoURL,
      'fullName': fullName,
      'chips': chips,
      'cardCount': cardCount,
      'uid': uid,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Player(name: $name, username: $username, photoURL: $photoURL, fullName: $fullName, chips: $chips, cardCount: $cardCount, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Player &&
      other.name == name &&
      other.username == username &&
      other.photoURL == photoURL &&
      other.fullName == fullName &&
      other.chips == chips &&
      other.cardCount == cardCount &&
      other.uid == uid;
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'],
      username: map['username'] ?? '',
      photoURL: map['photoURL'] ?? '',
      fullName: map['fullName'],
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
      photoURL.hashCode ^
      fullName.hashCode ^
      chips.hashCode ^
      cardCount.hashCode ^
      uid.hashCode;
  }
}
