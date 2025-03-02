import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/authentication/logic/auth.dart';
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
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Navigator.pushReplacementNamed(context, '/login'); // TO DO: add home page - constant
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
              PasswordTextField(
                controller: _passwordController, labelText: "Hasło",),
              const SizedBox(height: 15),
              PasswordTextField(controller: _confirmPasswordController,
                  labelText: "Powtórz hasło"),
              const SizedBox(height: 20),
              CustomButton(
                text: "ZAREJESTRUJ",
                onPressed: () {
                  final email = _emailController.text;
                  final username = _nameController.text;
                  final password = _passwordController.text;
                  BlocProvider.of<AuthenticationCubit>(context)
                      .register(email, username, password);
                },
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
    );
  }
}
