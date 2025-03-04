import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "WITAJ W FIXIE!",
                  style: TextStyle(
                    fontSize: FontConstants.headerFontSize,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.whiteColor,
                  ),
                ),
                const SizedBox(height: 30),
                const RegisterForm(),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouteConstants.loginRoute);
                  },
                  child: Text(
                    "Masz już konto? Zaloguj się",
                    style:
                    TextStyle(
                      color: ColorConstants.whiteColor,
                      fontSize: FontConstants.smallFontSize,
                      fontWeight: FontWeight.w600,
                      decoration:
                      TextDecoration.underline,
                      decorationColor: ColorConstants.whiteColor,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
