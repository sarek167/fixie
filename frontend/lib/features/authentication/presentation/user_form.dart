import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/services/auth_service.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/auth.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/email_text_field.dart';
import 'package:frontend/widgets/password_text_field.dart';
import 'package:frontend/widgets/standard_text_field.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: UserStorage().getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return Form(
            child:
            Column(
              children: [
                Text(
                  snapshot.hasError || snapshot.data == null ?
                  "Witaj!"
                      : "Witaj ${snapshot.data!.username}!",
                  style: TextStyle(
                    color: ColorConstants.white,
                    fontSize: FontConstants.largeHeaderFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                EmailTextField(controller: _emailController,
                    isEnabled: false,
                    labelText: snapshot.data!.email),
                const SizedBox(height: 15),
                StandardTextField(controller: _usernameController,
                    isEnabled: false,
                    labelText: snapshot.data!.username),
                const SizedBox(height: 15),
                StandardTextField(controller: _firstNameController,
                    isEnabled: isEditing,
                    labelText: (snapshot.data?.firstName?.isNotEmpty) ?? false
                        ? snapshot.data!.firstName!
                        : "Imię"),
                const SizedBox(height: 15),
                StandardTextField(controller: _lastNameController,
                    isEnabled: isEditing,
                    labelText: (snapshot.data?.lastName?.isNotEmpty) ?? false
                        ? snapshot.data!.lastName!
                        : "Nazwisko"),
                const SizedBox(height: 15),
                if (isEditing)
                  PasswordTextField(
                    controller: _passwordController, labelText: "Stare hasło",
                  ),
                if (isEditing)
                  const SizedBox(height: 15),
                if (isEditing)
                  PasswordTextField(
                    controller: _newPasswordController, labelText: "Nowe hasło",),
                if (isEditing)
                  const SizedBox(height: 15),
                if (isEditing)
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Powtórz nowe hasło",
                      filled: true,
                      fillColor: ColorConstants.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wpisz ponownie hasło!";
                      }
                      if (value != _newPasswordController.text) {
                        return "Hasła się nie zgadzają!";
                      }
                      return null;
                    },
                  ),

                const SizedBox(height: 20),
                CustomButton(
                  text: isEditing ? "Zapisz" : "Modyfikuj",
                  onPressed: () async {
                    if (isEditing) {
                      final updatedData = {
                        "email": _emailController.text,
                        if (_firstNameController.text.isNotEmpty)
                          "first_name": _firstNameController.text,
                        if (_lastNameController.text.isNotEmpty)
                          "last_name": _lastNameController.text,
                        if (_passwordController.text.isNotEmpty)
                          "password": _passwordController.text,
                        if (_newPasswordController.text.isNotEmpty)
                          "new_password": _newPasswordController.text,
                      };

                      final success = await AuthService().changeUserData(updatedData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(success ? "Zapisano!" : "Coś poszło nie tak")),
                      );

                      if (success) {
                        setState(() {
                          isEditing = false;
                        });
                      }
                    } else {
                      setState(() {
                        isEditing = true;
                      });
                    }
                  },
                  backgroundColor: ColorConstants.dark,
                  width: 250,
                  height: 50,
                  textColor: ColorConstants.white,
                  fontSize: FontConstants.buttonFontSize,
                ),
              ],
            )
        );
      },
    );

  }
}
