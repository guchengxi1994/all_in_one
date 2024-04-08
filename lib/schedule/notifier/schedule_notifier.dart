import 'package:all_in_one/common/color_utils.dart';
import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/schedule.dart';
import 'package:all_in_one/schedule/notifier/schedule_state.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class ScheduleNotifier extends AutoDisposeNotifier<ScheduleState> {
  final IsarDatabase database = IsarDatabase();

  @override
  ScheduleState build() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime last =
        today.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    final items = database.isar!.scheduleItems
        .filter()
        .fromInMillBetween(
            today.millisecondsSinceEpoch, last.millisecondsSinceEpoch)
        .or()
        .toInMillBetween(
            today.millisecondsSinceEpoch, last.millisecondsSinceEpoch)
        .findAllSync();

    for (final i in items) {
      i.color = ColorUtil.getColorFromHex(i.colorInHex);
      i.from = DateTime.fromMillisecondsSinceEpoch(i.fromInMill);
      i.to = DateTime.fromMillisecondsSinceEpoch(i.toInMill);
    }

    return ScheduleState(items: items, start: today, end: last);
  }

  addEvent(
      {required DateTime from,
      required DateTime to,
      required String eventName,
      Color background = AppStyle.appColor,
      bool isAllDay = false}) async {
    ScheduleItem item = ScheduleItem()
      ..color = background
      ..eventName = eventName
      ..isAllDay = isAllDay
      ..from = from
      ..to = to;
    await database.isar!.writeTxn(() async {
      await database.isar!.scheduleItems.put(item);
    });

    if ((from.isAfter(state.start) && from.isBefore(state.end)) ||
        (to.isAfter(state.start) && to.isBefore(state.end))) {
      onViewChange([state.start, state.end]);
    }
  }

  onViewChange(List<DateTime> datetimes) {
    DateTime first = datetimes.first;
    DateTime last =
        datetimes.last.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    final items = database.isar!.scheduleItems
        .filter()
        .fromInMillBetween(
            first.millisecondsSinceEpoch, last.millisecondsSinceEpoch)
        .or()
        .toInMillBetween(
            first.millisecondsSinceEpoch, last.millisecondsSinceEpoch)
        .findAllSync();

    for (final i in items) {
      i.color = ColorUtil.getColorFromHex(i.colorInHex);
      i.from = DateTime.fromMillisecondsSinceEpoch(i.fromInMill);
      i.to = DateTime.fromMillisecondsSinceEpoch(i.toInMill);
    }

    state = ScheduleState(items: items, start: first, end: last);
  }
}

final scheduleProvider =
    AutoDisposeNotifierProvider<ScheduleNotifier, ScheduleState>(
        () => ScheduleNotifier());
