import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CatalogIcons {
  CatalogIcons._();
  static final Map<String, dynamic> _icons = {
    "game": HeroIcons.puzzle_piece,
    "tool": AntDesign.tool_fill
  };

  static Icon? getByName(String s) {
    if (_icons[s] != null) {
      return Icon(
        _icons[s],
        size: 20,
      );
    }
    return null;
  }
}
