class User {
  int _id;
  String _email;
  String _username;
  String? _firstName;
  String? _lastName;
  int _streak;

  User({
    required int id,
    required String email,
    required String username,
    String? firstName,
    String? lastName,
    int? streak,
  })  :
        _id = id,
        _email = email,
        _username = username,
        _firstName = firstName,
        _lastName = lastName,
        _streak = streak ?? 0;

  int get id => _id;
  String get email => _email;
  String get username => _username;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  int get streak => _streak;

  set id(int value) => _id = value;
  set email(String value) => _email = value;
  set username(String value) => _username = value;
  set firstName(String? value) => _firstName = value;
  set lastName(String? value) => _lastName = value;
  set streak(int value) => _streak = value;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      streak: json['streak']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'email': _email,
      'username': _username,
      'first_name': _firstName,
      'last_name': _lastName,
      'streak': _streak,
    };
  }
}
