import 'package:flutter/material.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/email_text_field.dart';
import 'package:frontend/widgets/password_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      print("Logowanie użytkownika: ${_emailController.text}");
      // Tu wywołanie funkcji logowania (np. Firebase lub API)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailTextField(controller: _emailController),
          const SizedBox(height: 15),
          PasswordTextField(controller: _passwordController, labelText: "Hasło",),
          const SizedBox(height: 20),
          CustomButton(
            text: "Zaloguj",
            onPressed: _login,
            backgroundColor: Colors.red,
            width: 250,
            height: 50,
            textColor: Colors.white,
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}
