import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CatalogIcons {
  CatalogIcons._();
  static final Map<String, dynamic> icons = {
    "game": HeroIcons.puzzle_piece,
    "tool": AntDesign.tool_fill
  };

  static Icon? getByName(String? s, {Color color = AppStyle.appColor}) {
    if (s == null) {
      return null;
    }
    if (icons[s] != null) {
      return Icon(
        icons[s],
        size: 20,
        color: color,
      );
    }
    return null;
  }
}
