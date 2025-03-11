import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/authentication/logic/auth.dart';
import '../../../widgets/button.dart';
import '../../../widgets/email_text_field.dart';
import '../../../widgets/password_text_field.dart';
import '../../../widgets/standard_text_field.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hasła się nie zgadzają!"),
            backgroundColor: ColorConstants.darkColor,
          ),
        );
        return;
      }
      print("Rejestracja użytkownika: ${_emailController.text}");
      final email = _emailController.text;
      final username = _nameController.text;
      final password = _passwordController.text;
      BlocProvider.of<AuthenticationCubit>(context)
          .register(email, username, password);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRouteConstants.homeRoute); // TO DO: add home page - constant
          }
          if (state is AuthenticationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Błąd rejestracji: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                EmailTextField(controller: _emailController),
                const SizedBox(height: 15),
                StandardTextField(
                    controller: _nameController, labelText: "Nazwa"),
                const SizedBox(height: 15),
                StandardTextField(
                    controller: _nameController, labelText: "Imię"),
                const SizedBox(height: 15),
                StandardTextField(
                    controller: _nameController, labelText: "Nazwisko"),
                const SizedBox(height: 15),
                PasswordTextField(
                  controller: _passwordController, labelText: "Hasło",),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Powtórz hasło",
                    filled: true,
                    fillColor: ColorConstants.whiteColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Wpisz ponownie hasło!";
                    }
                    if (value != _passwordController.text) {
                      return "Hasła się nie zgadzają!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "ZAPISZ",
                  onPressed: () {
                    _register();
                  },
                  backgroundColor: ColorConstants.darkColor,
                  width: 250,
                  height: 50,
                  textColor: ColorConstants.whiteColor,
                  fontSize: FontConstants.buttonFontSize,
                ),
              ],
            ),
          );
        }
    );
  }
}
