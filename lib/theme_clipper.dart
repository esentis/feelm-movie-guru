import 'dart:ui';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

@immutable
class ThemeCustomClipper implements ThemeSwitcherClipper {
  const ThemeCustomClipper();

  @override
  Path getClip(Size size, Offset offset, double sizeRate) {
    return Path()
      ..addOval(
          Rect.fromCircle(center: offset, radius: size.height * sizeRate));
  }

  @override
  bool shouldReclip(
      CustomClipper<Path> oldClipper, Offset offset, double sizeRate) {
    return true;
  }
}
