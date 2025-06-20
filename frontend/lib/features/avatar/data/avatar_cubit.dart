import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/avatar_service.dart';
import 'package:frontend/features/avatar/data/avatar_state.dart';

class AvatarCubit extends Cubit<AvatarState>{
  AvatarCubit() : super(
    AvatarState(
      skinColor: "1",
      eyesColor: "blue",
      hair: "braids",
      hairColor: "black",
      topClothes: "basic",
      topClothesColor: "light-green",
      bottomClothes: "pants",
      bottomClothesColor: "black"
    )
  );

  Future<void> loadAvatar() async {
    try {
      final fetchedState = await AvatarService.getAvatarState();
      emit(fetchedState);
    } catch (e) {
      print("Error loading avatar: $e");
    }
  }

  void updatePart(String part, String value) async {
    AvatarState newState;
    switch (part) {
      case "skinColor":
        newState = state.copyWith(skinColor: value);
        break;
      case "eyesColor":
        newState = state.copyWith(eyesColor: value);
        break;
      case "hair":
        newState = state.copyWith(hair: value.split("-")[0]);
        break;
      case "hairColor":
        newState = state.copyWith(hairColor: value.split("-")[1]);
        break;
      case "topClothes":
        newState = state.copyWith(topClothes: value.split("-")[0]);
        break;
      case "topClothesColor":
        newState = state.copyWith(topClothesColor: value.split("-")[1]);
        break;
      case "bottomClothes":
        newState = state.copyWith(bottomClothes: value.split("-")[0]);
        break;
      case "bottomClothesColor":
        newState = state.copyWith(bottomClothesColor: value.split("-")[1]);
        break;
      case "lipstick":
        newState = state.copyWith(lipstick: value);
        break;
      case "blush":
        newState = state.copyWith(blush: value);
        break;
      default:
        return;
    }
    emit(newState);

    try {
      await AvatarService.updateAvatarState(newState);
    } catch (e) {
      print("Error updating avatar: $e");
    }
  }
}