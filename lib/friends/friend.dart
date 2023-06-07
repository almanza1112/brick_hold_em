import 'dart:convert';

class Friend {

  String username;
  String? fullName;
  String photoURL;
  String status;
  
  Friend({
    required this.username,
    this.fullName,
    required this.photoURL,
    required this.status,
  });
  

  Friend copyWith({
    String? username,
    String? fullName,
    String? photoURL,
    String? status,
  }) {
    return Friend(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoURL: photoURL ?? this.photoURL,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'fullName': fullName,
      'photoURL': photoURL,
      'status': status,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      username: map['username'] ?? '',
      fullName: map['fullName'],
      photoURL: map['photoURL'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Friend.fromJson(String source) => Friend.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Friend(username: $username, fullName: $fullName, photoURL: $photoURL, status: $status)';
  }

}
