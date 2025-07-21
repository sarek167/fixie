import 'package:frontend/features/avatar/data/avatar_state.dart';

bool isEmptyAvatar(AvatarState avatar) {
  return avatar.skinColor.trim().isEmpty ||
      avatar.hair.trim().isEmpty ||
      avatar.topClothes.trim().isEmpty;
}
