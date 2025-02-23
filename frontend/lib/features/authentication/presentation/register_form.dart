import 'package:flutter/material.dart';
import '../../../widgets/button.dart';
import '../../../widgets/email_text_field.dart';
import '../../../widgets/password_text_field.dart';
import '../../../widgets/standard_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      print("Rejestracja użytkownika: ${_emailController.text}");
      // Tutaj wywołanie funkcji rejestracji (np. Firebase lub API)
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
          StandardTextField(controller: _nameController, labelText: "Nazwa"),
          const SizedBox(height: 15),
          PasswordTextField(controller: _passwordController, labelText: "Hasło",),
          const SizedBox(height: 15),
          PasswordTextField(controller: _confirmPasswordController, labelText: "Powtórz hasło"),
          const SizedBox(height: 20),
          CustomButton(
            text: "ZAREJESTRUJ",
            onPressed: _register,
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
