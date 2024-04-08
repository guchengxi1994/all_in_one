import 'package:flutter/material.dart';

class ColorUtil {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  static Color getColorFromHex(String hexColor) {
    return Color(_getColorFromHex(hexColor));
  }

  static String toHex(Color c) {
    return c.value.toRadixString(16);
  }
}
