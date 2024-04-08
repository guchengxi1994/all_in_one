import 'package:flutter/material.dart';

RegExp timeRegex = RegExp(r'^(\d{2}):(\d{2}) (AM|PM)$');

extension ToDateTime on String {
  TimeOfDay? toTime() {
    if (!timeRegex.hasMatch(this)) {
      return null;
    }
    final sp1 = split(" ");
    final sp2 = sp1.first.split(":");
    return TimeOfDay(
        hour:
            sp1.last == "AM" ? int.parse(sp2.first) : int.parse(sp2.first) + 12,
        minute: int.parse(sp2.last));
  }
}
