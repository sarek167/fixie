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
  String beard;

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
    this.blush = "0",
    this.beard = "0"
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
    String? beard,
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
      beard: beard ?? this.beard,
    );
    print(state.hair);
    print(state.eyesColor);
    return state;
  }

  factory AvatarState.fromJson(Map<String, dynamic> json) {
    return AvatarState(
      skinColor: json['skinColor'] ?? "",
      eyesColor: json['eyesColor'] ?? "",
      hair: json['hair'] ?? "",
      hairColor: json['hairColor'] ?? "",
      topClothes: json['topClothes'] ?? "",
      topClothesColor: json['topClothesColor'] ?? "",
      bottomClothes: json['bottomClothes'] ?? "",
      bottomClothesColor: json['bottomClothesColor'] ?? "",
      lipstick: json['lipstick'] ?? "",
      blush: json['blush'] ?? "",
      beard: json['beard'] ?? "",
    );
  }


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
    'beard': beard,
  };
}