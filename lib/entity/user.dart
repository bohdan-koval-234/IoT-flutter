class User {
  final String email;
  final String password;

  User(this.email, this.password);

  static User fromJson(Map<String, dynamic> userJson) {
    return User(
      userJson['email'] as String,
      userJson['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  User copyWith({
    String? email,
    String? password,
  }) {
    return User(
      email ?? this.email,
      password ?? this.password,
    );
  }
}
