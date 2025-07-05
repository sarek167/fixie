import 'package:flutter/material.dart';
import 'package:frontend/features/avatar/presentation/avatar_carousel.dart';

class AvatarSingleTab {
  final Color backgroundColor;
  final List<AvatarCarousel> carousels;

  const AvatarSingleTab ({
    required this.backgroundColor,
    required this.carousels
  });
}