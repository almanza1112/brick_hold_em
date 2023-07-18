class User {
  final String username;
  final String fullName;
  final String photoURL;
  final int chips;

  User(
    this.username,
    this.fullName,
    this.photoURL,
    this.chips,
  );

  static User fromJson(Map<String, dynamic> json) {
    //return User(json['username'], json['fullName'], json['photoURL'], json['chips']);
    return User(
      json['username'] ?? '',
      json['fullName'] ?? '',
      json['photoURL'] ?? '',
      json['chips'] ?? 0,
    );
  }
}
