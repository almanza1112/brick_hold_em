import 'package:flutter/material.dart';

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
}
