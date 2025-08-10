import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isEnabled;

  const EmailTextField({
    Key? key,
    required this.controller,
    this.labelText = "Email",
    this.isEnabled=true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: ColorConstants.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Wpisz adres e-mail!";
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Podaj poprawny adres e-mail!";
        }
        return null;
      },
    );
  }
}
