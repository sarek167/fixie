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
        color: ColorConstants.whiteColor,
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
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/bottom-clothes/${avatar.bottomClothes}-${avatar.bottomClothesColor}.png', filterQuality: FilterQuality.none,),
              ),
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/top-clothes/basic-light-green.png', filterQuality: FilterQuality.none,),
              ),
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/hair/braids-red.png', filterQuality: FilterQuality.none,),
              ),
              Transform.scale(
                scale: 8,
                child: Image.asset('lib/assets/images/eyes.png', filterQuality: FilterQuality.none,),
              ),
              Transform.scale(
                scale: 8,
                child: Image.network('https://${AvatarStorage.storageName}.blob.core.windows.net/blush/3.png', filterQuality: FilterQuality.none,),
              ),
              // Transform.scale(
              //   scale: 8,
              //   child: Image.network('https://fixieavatarimg.blob.core.windows.net/lipstick/3.png', filterQuality: FilterQuality.none,),
              // ),
              // Transform.scale(
              //   scale: 8,
              //   scale: 8,
              //   child: Image.network('https://fixieavatarimg.blob.core.windows.net/accessories/beard-red.png', filterQuality: FilterQuality.none,),
              // ),
            ],
          )
        )
      )
    );
  }
}