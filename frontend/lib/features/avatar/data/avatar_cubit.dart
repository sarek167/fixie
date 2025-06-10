import 'package:flutter_bloc/flutter_bloc.dart';
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


  void updatePart(String part, String value) {
    switch (part) {
      case "skinColor":
        emit(state.copyWith(skinColor: value));
        break;
      case "eyesColor":
        emit(state.copyWith(eyesColor: value));
        break;
      case "hair":
        emit(state.copyWith(hair: value.split("-")[0]));
        break;
      case "hairColor":
        emit(state.copyWith(hairColor: value.split("-")[1]));
        break;
      case "topClothes":
        emit(state.copyWith(topClothes: value.split("-")[0]));
        break;
      case "topClothesColor":
        emit(state.copyWith(topClothesColor: value.split("-")[1]));
        break;
      case "bottomClothes":
        emit(state.copyWith(bottomClothes: value.split("-")[0]));
        break;
      case "bottomClothesColor":
        emit(state.copyWith(bottomClothesColor: value.split("-")[1]));
        break;
      case "lipstick":
        emit(state.copyWith(lipstick: value));
        break;
      case "blush":
        emit(state.copyWith(blush: value));
        break;
    }
    emit(state);
  }
}