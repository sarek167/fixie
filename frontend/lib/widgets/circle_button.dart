import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/home/presentation/home_screen.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: ColorConstants.darkColor,
        child: Icon(Icons.edit, color: ColorConstants.whiteColor,),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRouteConstants.avatarRoute,
          );
        },
      ),
    );
  }
}