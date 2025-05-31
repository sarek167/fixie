import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';

class AvatarCarousel extends StatelessWidget{
  final String title;
  final List<Color>? colors;
  final List<String>? images;

  const AvatarCarousel({
    super.key,
    required this.title,
    this.colors,
    this.images,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    if (colors != null && colors!.isNotEmpty) {
      items = colors!.map((color) => GestureDetector(
        onTap: () {
          print("Kliknięto kolor");
          // dodaj logikę wyboru koloru
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.white, width: 4),
          ),
        ),
      )
      ).toList();
    } else if (images != null && images!.isNotEmpty) {
      items = images!.map((imagePath) => GestureDetector(
        onTap: () {
          print("Kliknięto zdjęcie");
          print(imagePath);
          // dodaj logikę wyboru koloru
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.white, width: 4),
          ),
          child: ClipOval(
            child: Image.network(imagePath, fit: BoxFit.cover, filterQuality: FilterQuality.none,),
          )
        ),
      )
      ).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: FontConstants.headerFontSize,
            color: ColorConstants.whiteColor)),
        SizedBox(height: FontConstants.standardFontSize),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
            children: items
            ),
          )
        ),
        SizedBox(height: 16),
      ],
    );
  }
}