import 'dart:convert';

class Player {
  final String? name;
  final String? username;
  final String? photoUrl;
  final int? chips;
  final String? uid;

  Player({
    this.name,
    this.username,
    this.photoUrl,
    this.chips,
    this.uid,
  });


  Player copyWith({
    String? name,
    String? username,
    String? photoUrl,
    int? chips,
    String? uid,
  }) {
    return Player(
      name: name ?? this.name,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      chips: chips ?? this.chips,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'photoUrl': photoUrl,
      'chips': chips,
      'uid': uid,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Player(name: $name, username: $username, photoUrl: $photoUrl, chips: $chips, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Player &&
      other.name == name &&
      other.username == username &&
      other.photoUrl == photoUrl &&
      other.chips == chips &&
      other.uid == uid;
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'],
      username: map['username'],
      photoUrl: map['photoUrl'] ?? '',
      chips: map['chips']?.toInt() ?? 0,
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
      uid.hashCode;
  }
}