import 'package:flutter/material.dart';

abstract class SidemenuItem {
  const SidemenuItem({this.title, this.onTap});
  final String? title;
  final VoidCallback? onTap;

  Widget toWidget({BuildContext? context});
}
