import 'dart:convert';

class Friend {

  String uid;
  String username;
  String? fullName;
  String photoURL;
  String status;
  
  Friend({
    required this.uid,
    required this.username,
    this.fullName,
    required this.photoURL,
    required this.status,
  });
  

  Friend copyWith({
    String? uid,
    String? username,
    String? fullName,
    String? photoURL,
    String? status,
  }) {
    return Friend(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoURL: photoURL ?? this.photoURL,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'fullName': fullName,
      'photoURL': photoURL,
      'status': status,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      uid: map['uid'] ?? '',
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
    return 'Friend(uid: $uid, username: $username, fullName: $fullName, photoURL: $photoURL, status: $status)';
  }
}
