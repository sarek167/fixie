class AvatarState {
  int skinColor;
  String eyesColor;
  String hair;
  String hairColor;
  String topClothes;
  String topClothesColor;
  String bottomClothes;
  String bottomClothesColor;
  int lipstick;
  int blush;

  AvatarState({
    required this.skinColor,
    required this.eyesColor,
    required this.hair,
    required this.hairColor,
    required this.topClothes,
    required this.topClothesColor,
    required this.bottomClothes,
    required this.bottomClothesColor,
    this.lipstick = 0,
    this.blush = 0
  });
}