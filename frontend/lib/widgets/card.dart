import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';


class CardItem extends StatelessWidget{
  final String? imageUrl;
  final String text;
  final Color? backgroundColor;

  CardItem({
    this.imageUrl,
    required this.text,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: imageUrl != null
              ? ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4), // Przyciemnienie
              BlendMode.darken,
            ),
            child: Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
          )
              : Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.grey, // Tło jako kolor
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28, // ✅ Duży tekst
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
