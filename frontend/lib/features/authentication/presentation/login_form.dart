import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/authentication/logic/auth.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/email_text_field.dart';
import 'package:frontend/widgets/password_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home'); // TO DO: add home page - constant
          }
          if (state is AuthenticationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Błąd logowanie: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Form(
            child:
            Column(
              children: [
                EmailTextField(controller: _emailController),
                const SizedBox(height: 15),
                PasswordTextField(controller: _passwordController, labelText: "Hasło",),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Zaloguj",
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    BlocProvider.of<AuthenticationCubit>(context)
                        .login(email, password);
                  },
                  backgroundColor: ColorConstants.darkColor,
                  width: 250,
                  height: 50,
                  textColor: ColorConstants.whiteColor,
                  fontSize: 18,
                ),
              ],
            )
          );
        }
    );
  }
}
