import 'dart:convert';

import 'package:flutter/widgets.dart';

class Player {
  final String? name;
  final String username;
  final String photoURL;
  final String? fullName;
  final String uid;
  final int position;
  final bool folded;

  Player({
    this.name,
    required this.username,
    required this.photoURL,
    this.fullName,
    required this.uid,
    required this.position,
    required this.folded,
  });


  Player copyWith({
    ValueGetter<String?>? name,
    String? username,
    String? photoURL,
    ValueGetter<String?>? fullName,
    String? uid,
    int? position,
    bool? folded,
  }) {
    return Player(
      name: name?.call() ?? this.name,
      username: username ?? this.username,
      photoURL: photoURL ?? this.photoURL,
      fullName: fullName?.call() ?? this.fullName,
      uid: uid ?? this.uid,
      position: position ?? this.position,
      folded: folded ?? this.folded,
    );
  }

 

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'photoURL': photoURL,
      'fullName': fullName,
      'uid': uid,
      'position': position,
      'folded': folded,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'],
      username: map['username'] ?? '',
      photoURL: map['photoURL'] ?? '',
      fullName: map['fullName'],
      uid: map['uid'] ?? '',
      position: map['position']?.toInt() ?? 0,
      folded: map['folded'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Player(name: $name, username: $username, photoURL: $photoURL, fullName: $fullName, uid: $uid, position: $position, folded: $folded)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Player &&
      other.name == name &&
      other.username == username &&
      other.photoURL == photoURL &&
      other.fullName == fullName &&
      other.uid == uid &&
      other.position == position &&
      other.folded == folded;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      username.hashCode ^
      photoURL.hashCode ^
      fullName.hashCode ^
      uid.hashCode ^
      position.hashCode ^
      folded.hashCode;
  }
}
