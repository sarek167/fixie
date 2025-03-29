import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';


class CardItem extends StatelessWidget{
  final String? imageUrl;
  final String text;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final double backgroundDarkening;
  final String routeName;
  final Color textColor;

  const CardItem({
    super.key,
    this.imageUrl,
    required this.text,
    this.backgroundColor,
    this.height = 250,
    this.borderRadius = 15,
    this.backgroundDarkening = 0.5,
    required this.routeName,
    this.textColor = ColorConstants.whiteColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          routeName,
          arguments: {
            'title': text
          }
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: imageUrl != null
                ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                ColorConstants.blackColor.withValues(alpha: backgroundDarkening),
                BlendMode.darken,
              ),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: height,
              ),
            )
                : Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor ?? ColorConstants.blackColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Text(
                text,
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: FontConstants.headerFontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            )
          ),
        ],
      )
    );
  }
}
