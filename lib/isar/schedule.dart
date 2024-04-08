import 'package:all_in_one/common/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

part 'schedule.g.dart';

@collection
class ScheduleItem {
  Id id = Isar.autoIncrement;

  late String eventName;
  @Ignore()
  late DateTime from;
  @Ignore()
  late DateTime to;

  late int fromInMill = from.millisecondsSinceEpoch;
  late int toInMill = to.millisecondsSinceEpoch;

  @Ignore()
  late Color color;

  late String colorInHex = ColorUtil.toHex(color);
  late bool isAllDay = false;
}

class ScheduleItemSource extends CalendarDataSource {
  ScheduleItemSource(List<ScheduleItem> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getData(index).color;
  }

  @override
  bool isAllDay(int index) {
    return _getData(index).isAllDay;
  }

  ScheduleItem _getData(int index) {
    final dynamic item = appointments![index];
    late final ScheduleItem data;
    if (item is ScheduleItem) {
      data = item;
    }

    return data;
  }
}
