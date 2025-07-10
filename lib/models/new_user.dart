import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
class NewUser {
  final String? fullName;
  final String? email;
  final String? password;
  final String? username;
  final String? photoURL;
  final String? loginType; // Only three login types "facebook", "google", "email"

  const NewUser({
    this.fullName, 
    this.email, 
    this.password, 
    this.username, 
    this.photoURL,
    this.loginType,
    });

  NewUser copyWith({
    String? fullName,
    String? email,
    String? password,
    String? username,
    String? photoURL,
    String? loginType,
  }) {
    return NewUser(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      photoURL: photoURL ?? this.photoURL,
      loginType: loginType ?? this.loginType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'username': username,
      'photoURL': photoURL,
      'loginType': loginType,
    };
  }

  factory NewUser.fromMap(Map<String, dynamic> map) {
    return NewUser(
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      username: map['username'],
      photoURL: map['photoURL'],
      loginType: map['loginType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NewUser.fromJson(String source) => NewUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NewUser(fullName: $fullName, email: $email, password: $password, username: $username, photoURL: $photoURL, loginType: $loginType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NewUser &&
      other.fullName == fullName &&
      other.email == email &&
      other.password == password &&
      other.username == username &&
      other.photoURL == photoURL &&
      other.loginType == loginType;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
      email.hashCode ^
      password.hashCode ^
      username.hashCode ^
      photoURL.hashCode ^
      loginType.hashCode;
  }
}
