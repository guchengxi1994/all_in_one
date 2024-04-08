import 'package:all_in_one/isar/schedule.dart';

class ScheduleState {
  List<ScheduleItem> items;
  final DateTime start;
  final DateTime end;
  ScheduleState(
      {this.items = const [], required this.end, required this.start});
}
