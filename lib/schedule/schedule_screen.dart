import 'dart:math';

import 'package:all_in_one/isar/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'notifier/schedule_notifier.dart';

class ScheduleScreen extends ConsumerWidget {
  ScheduleScreen({super.key});

  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _addDataSource(ref);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SfCalendar(
            controller: _controller,
            allowDragAndDrop: false,
            allowViewNavigation: true,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month,
              CalendarView.schedule,
            ],
            // view: state.current,
            dataSource: ScheduleItemSource(ref.watch(scheduleProvider).items),
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
          ),
        ));
  }

  _addDataSource(WidgetRef ref) {
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, Random().nextInt(12));
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    ref.read(scheduleProvider.notifier).addEvent(
          from: startTime,
          to: endTime,
          eventName: "balabala",
        );

    // meetings.add(Meeting(
    //     'Conference', startTime, endTime, const Color(0xFF0F8644), false));
  }
}
