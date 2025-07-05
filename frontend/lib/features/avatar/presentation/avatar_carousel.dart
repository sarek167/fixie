import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/avatar/data/avatar_cubit.dart';
import 'package:frontend/features/avatar/data/avatar_option_item.dart';

class AvatarCarousel extends StatelessWidget{
  final String title;
  final String partKey;
  final List<AvatarOptionItem> options;
  final bool isColor;
  final bool hasEmpty;

  const AvatarCarousel({
    super.key,
    required this.title,
    required this.partKey,
    required this.options,
    this.isColor = true,
    this.hasEmpty = false
  });

  @override
  Widget build(BuildContext context) {
    final displayedOptions = !isColor
        ? {
          for (var o in options.reversed) o.label.split("-")[0]: o
        }.values.toList()
        : {
          for (var o in options) o.color: o
        }.values.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: FontConstants.headerFontSize,
            color: ColorConstants.white)),
        SizedBox(height: FontConstants.standardFontSize),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
            children: [
              if (hasEmpty)
                GestureDetector(
                  onTap: () {
                    context.read<AvatarCubit>().updatePart(partKey, "0");
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.white,
                    ),
                    child: Center(
                      child: Icon(Icons.close, color: ColorConstants.dark, size: FontConstants.largeHeaderFontSize)
                    )
                  ),
                ),
              ...displayedOptions.map((option) {
                return GestureDetector(
                    onTap: () => {
                      context.read<AvatarCubit>().updatePart(partKey, option.label)
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color:ColorConstants.white, width: 4),
                          color: isColor ? option.color : ColorConstants.white
                      ),
                      child: !isColor && option.imageUrl != null
                          ? ClipOval(child: Image.network(option.imageUrl!, fit: BoxFit.cover))
                          : null,
                    )
                );
              }),
            ]
            ),
          )
        ),
        SizedBox(height: 16),
      ],
    );
  }
}