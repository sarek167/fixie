import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserStorage {
  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? username = prefs.getString("username");
    String? firstName = prefs.getString("first_name");
    String? lastName = prefs.getString("last_name");
    int? streak = prefs.getInt("streak");

    if (email != null && username != null) {
      return User(
        email: email,
        username: username,
        firstName: firstName,
        lastName: lastName,
        streak: streak
      );
    }
    return null;
  }

  Future<void> setUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", user.email);
    await prefs.setString("username", user.username);
    await prefs.setInt("streak", user.streak);

    if (user.firstName != null) {
      await prefs.setString("first_name", user.firstName!);
    } else {
      await prefs.remove("first_name");
    }

    if (user.lastName != null) {
      await prefs.setString("last_name", user.lastName!);
    } else {
      await prefs.remove("last_name");
    }

  }

  Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("username");
    await prefs.remove("first_name");
    await prefs.remove("last_name");
    await prefs.remove("streak");
  }
}
