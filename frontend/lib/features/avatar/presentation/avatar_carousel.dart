import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/avatar/data/avatar_cubit.dart';
import 'package:frontend/features/avatar/data/avatar_option_item.dart';

class AvatarCarousel extends StatelessWidget{
  final String title;
  final String partKey;
  final List<AvatarOptionItem> options;

  const AvatarCarousel({
    super.key,
    required this.title,
    required this.partKey,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
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
            children: options.map((option) {
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
                    border: Border.all(color:ColorConstants.whiteColor, width: 4),
                    color: option.color ?? ColorConstants.whiteColor
                  ),
                  child: option.imageUrl != null
                    ? ClipOval(child: Image.network(option.imageUrl!, fit: BoxFit.cover))
                    : null,
                )
              );
            }).toList(),
            ),
          )
        ),
        SizedBox(height: 16),
      ],
    );
  }
}