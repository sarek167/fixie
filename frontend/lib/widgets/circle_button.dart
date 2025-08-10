import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/home/presentation/home_screen.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final String route;

  const CircleButton({
    super.key,
    required this.icon,
    required this.route
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: FloatingActionButton(
        heroTag: route,
        mini: true,
        backgroundColor: ColorConstants.dark,
        child: Icon(icon, color: ColorConstants.white,),
        onPressed: () {
          Navigator.pushNamed(
            context,
            route,
          );
        },
      ),
    );
  }
}