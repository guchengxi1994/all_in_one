import 'package:flutter/material.dart';

class NewScheduleModel {
  final List<DateTime?> dateTimes;
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Color pickedColor;

  NewScheduleModel(
      {required this.dateTimes,
      required this.endTime,
      required this.pickedColor,
      required this.startTime,
      required this.title});
}
