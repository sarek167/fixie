class User {
  String _email;
  String _username;
  String? _firstName;
  String? _lastName;

  User({
    required String email,
    required String username,
    String? firstName,
    String? lastName,
  })  : _email = email,
        _username = username,
        _firstName = firstName,
        _lastName = lastName;

  String get email => _email;
  String get username => _username;
  String? get firstName => _firstName;
  String? get lastName => _lastName;

  set email(String value) => _email = value;
  set username(String value) => _username = value;
  set firstName(String? value) => _firstName = value;
  set lastName(String? value) => _lastName = value;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'], // Może być null
      lastName: json['last_name'], // Może być null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': _email,
      'username': _username,
      'first_name': _firstName,
      'last_name': _lastName,
    };
  }
}
