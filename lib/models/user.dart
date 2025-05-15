class User {
  final String? id;
  final String email;
  final String? password;
  final String name;
  final bool isGuest;

  User({
    this.id,
    required this.email,
    this.password,
    required this.name,
    this.isGuest = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'isGuest': isGuest,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      isGuest: json['isGuest'] ?? false,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    bool? isGuest,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      isGuest: isGuest ?? this.isGuest,
    );
  }
} 