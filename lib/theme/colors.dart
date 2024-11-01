import 'package:flutter/material.dart';
import 'package:watchball/utils/utils.dart';

const white = Colors.white;
const black = Colors.black;
const red = Colors.red;
const transparent = Colors.transparent;
final lightBlack = Colors.black.withOpacity(0.7);
final lighterBlack = Colors.black.withOpacity(0.5);
final lightestBlack = Colors.black.withOpacity(0.1);
final faintBlack = Colors.black.withOpacity(0.04);

final lightWhite = Colors.white.withOpacity(0.7);
final lighterWhite = Colors.white.withOpacity(0.5);
final lightestWhite = Colors.white.withOpacity(0.1);
final faintWhite = Colors.white.withOpacity(0.04);

Color get bgTint => isDarkMode ? black : white;
Color get tint => isDarkMode ? white : black;
Color get lightTint => isDarkMode ? lightWhite : lightBlack;
Color get lighterTint => isDarkMode ? lighterWhite : lighterBlack;
Color get lightestTint => isDarkMode ? lightestWhite : lightestBlack;
Color get faintTint => isDarkMode ? faintWhite : faintBlack;

Color get dialogBgColor =>
    isDarkMode ? const Color(0xFF333333) : const Color(0xFFF2F2F2);
Color get dialogBgColor2 =>
    isDarkMode ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F2);

const primaryColor = Colors.purple;
