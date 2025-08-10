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
    String read(List<String> keys, {String fallback = ""}) {
      for (final k in keys) {
        final v = json[k];
        if (v == null) continue;
        final s = v.toString().trim();
        if (s.isNotEmpty && s != "-") return s; // odfiltruj "-"
      }
      return fallback;
    }

    return AvatarState(
      skinColor:         read(['skinColor', 'skin_color']),
      eyesColor:         read(['eyesColor', 'eyes_color']),
      hair:              read(['hair']),
      hairColor:         read(['hairColor', 'hair_color']),
      topClothes:        read(['topClothes', 'top_clothes']),
      topClothesColor:   read(['topClothesColor', 'top_clothes_color']),
      bottomClothes:     read(['bottomClothes', 'bottom_clothes']),
      bottomClothesColor:read(['bottomClothesColor', 'bottom_clothes_color']),
      lipstick:          read(['lipstick'],  fallback: "0"),
      blush:             read(['blush'],     fallback: "0"),
      beard:             read(['beard'],     fallback: "0"),
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