import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/widgets/menu_bar.dart';

class SingleTaskScreen extends StatelessWidget {
  const SingleTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: CustomAppBar(),
      body: Center(
        child:               Text(
          "POJEDYNCZE\nZADANIE",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorConstants.whiteColor,
            fontSize: FontConstants.largeHeaderFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}