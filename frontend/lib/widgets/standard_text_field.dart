import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';

class StandardTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isEnabled;

  const StandardTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isEnabled = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: ColorConstants.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Wpisz $labelText!";
        }
        return null;
      },
    );
  }
}
