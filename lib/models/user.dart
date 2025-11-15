class User {
  int? id;
  String username;
  String password;
  String email;
  DateTime createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}