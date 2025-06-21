import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/core/constants/avatar_storage.dart';
import 'package:frontend/features/avatar/data/avatar_cubit.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = context.watch<AvatarCubit>().state;
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/base/${avatar.skinColor}.png', filterQuality: FilterQuality.none,),
              ),
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/eyes/${avatar.eyesColor}.png', filterQuality: FilterQuality.none,),
              ),
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/bottom-clothes/${avatar.bottomClothes}-${avatar.bottomClothesColor}.png', filterQuality: FilterQuality.none,),
              ),
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/top-clothes/${avatar.topClothes}-${avatar.topClothesColor}.png', filterQuality: FilterQuality.none,),
              ),
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/hair/${avatar.hair}-${avatar.hairColor}.png', filterQuality: FilterQuality.none,),
              ),
              if (avatar.blush != "0")
                Transform.scale(
                  scale: 8,
                  child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/blush/${avatar.blush}.png', filterQuality: FilterQuality.none,),
                ),
              if (avatar.lipstick != "0")
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/lipstick/${avatar.lipstick}.png', filterQuality: FilterQuality.none,),
              ),
              if (avatar.beard != "0")
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/beard/${avatar.beard}.png', filterQuality: FilterQuality.none,),
              ),
            ],
          )
        )
      )
    );
  }
}