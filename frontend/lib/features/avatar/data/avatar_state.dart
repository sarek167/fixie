class AvatarState {
  String skinColor;
  String eyesColor;
  String hair;
  String hairColor;
  String topClothes;
  String topClothesColor;
  String bottomClothes;
  String bottomClothesColor;
  String lipstick;
  String blush;

  AvatarState({
    required this.skinColor,
    required this.eyesColor,
    required this.hair,
    required this.hairColor,
    required this.topClothes,
    required this.topClothesColor,
    required this.bottomClothes,
    required this.bottomClothesColor,
    this.lipstick = "0",
    this.blush = "0"
  });

  AvatarState copyWith({
    String? skinColor,
    String? eyesColor,
    String? hair,
    String? hairColor,
    String? topClothes,
    String? topClothesColor,
    String? bottomClothes,
    String? bottomClothesColor,
    String? lipstick,
    String? blush,
  }) {
    AvatarState state = AvatarState(
      skinColor: skinColor ?? this.skinColor,
      eyesColor: eyesColor ?? this.eyesColor,
      hair: hair ?? this.hair,
      hairColor: hairColor ?? this.hairColor,
      topClothes: topClothes ?? this.topClothes,
      topClothesColor: topClothesColor ?? this.topClothesColor,
      bottomClothes: bottomClothes ?? this.bottomClothes,
      bottomClothesColor: bottomClothesColor ?? this.bottomClothesColor,
      lipstick: lipstick ?? this.lipstick,
      blush: blush ?? this.blush,
    );
    print(state.hair);
    print(state.eyesColor);
    return state;
  }

  factory AvatarState.fromJson(Map<String, dynamic> json) => AvatarState(
    skinColor: json['skin_color'],
    eyesColor: json['eyes_color'],
    hair: json['hair'],
    hairColor: json['hair_color'],
    topClothes: json['top_clothes'],
    topClothesColor: json['top_clothes_color'],
    bottomClothes: json['bottom_clothes'],
    bottomClothesColor: json['bottom_clothes_color'],
    lipstick: json['lipstick'],
    blush: json['blush'],
  );

  Map<String, dynamic> toJson() => {
    'skin_color': skinColor,
    'eyes_color': eyesColor,
    'hair': hair,
    'hair_color': hairColor,
    'top_clothes': topClothes,
    'top_clothes_color': topClothesColor,
    'bottom_clothes': bottomClothes,
    'bottom_clothes_color': bottomClothesColor,
    'lipstick': lipstick,
    'blush': blush,
  };
}