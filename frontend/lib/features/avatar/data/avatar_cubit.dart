import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/avatar/data/avatar_state.dart';

class AvatarCubit extends Cubit<AvatarState>{
  AvatarCubit() : super(
    AvatarState(
      skinColor: 1,
      eyesColor: "blue",
      hair: "braids",
      hairColor: "black",
      topClothes: "basic",
      topClothesColor: "green",
      bottomClothes: "pants",
      bottomClothesColor: "black"
    )
  );


  void updatePart(String part, String value) {
    switch (part) {
      case "skinColor":
        state.skinColor = value as int;
        break;
      case "eyesColor":
        state.eyesColor = value;
        break;
      case "hair":
        state.hair = value;
        break;
      case "hairColor":
        state.hairColor = value;
        break;
      case "topClothes":
        state.topClothes = value;
        break;
      case "topClothesColor":
        state.topClothesColor = value;
        break;
      case "bottomClothes":
        state.bottomClothes = value;
        break;
      case "bottomClothesColor":
        state.bottomClothesColor = value;
        break;
      case "lipstick":
        state.lipstick = value as int;
        break;
      case "blush":
        state.blush = value as int;
        break;
    }
    emit(state);
  }
}