import 'dart:convert';

import 'package:flutter/widgets.dart';

class Message {
  final String uid;
  final int position;
  final String text;
  final String? photoURL;
  final String? username;
  final DateTime timestamp;
  Message({
    required this.uid,
    required this.position,
    required this.text,
    required this.photoURL,
    required this.username,
    required this.timestamp,
  });


  Message copyWith({
    String? uid,
    int? position,
    String? text,
    ValueGetter<String?>? photoURL,
    ValueGetter<String?>? username,
    DateTime? timestamp,
  }) {
    return Message(
      uid: uid ?? this.uid,
      position: position ?? this.position,
      text: text ?? this.text,
      photoURL: photoURL?.call() ?? this.photoURL,
      username: username?.call() ?? this.username,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'position': position,
      'text': text,
      'photoURL': photoURL,
      'username': username,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      uid: map['uid'] ?? '',
      position: map['position']?.toInt() ?? 0,
      text: map['text'] ?? '',
      photoURL: map['photoURL'],
      username: map['username'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));


  @override
  String toString() {
    return 'Message(uid: $uid, position: $position, text: $text, photoURL: $photoURL, username: $username, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Message &&
      other.uid == uid &&
      other.position == position &&
      other.text == text &&
      other.photoURL == photoURL &&
      other.username == username &&
      other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      position.hashCode ^
      text.hashCode ^
      photoURL.hashCode ^
      username.hashCode ^
      timestamp.hashCode;
  }
}
