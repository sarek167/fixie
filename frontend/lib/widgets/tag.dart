import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color tagColor;
  final Color textColor;

  const Tag({
    Key? key,
    required this.text,
    this.tagColor = ColorConstants.semiLight,
    this.textColor = ColorConstants.white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: FontConstants.smallFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
