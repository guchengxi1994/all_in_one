import 'dart:math';

import 'package:all_in_one/isar/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'components/new_schedule_dialog.dart';
import 'notifier/schedule_notifier.dart';

class ScheduleScreen extends ConsumerWidget {
  ScheduleScreen({super.key});

  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(scheduleProvider);

    return notifier.when(
      data: (state) => Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await showGeneralDialog(
                  context: context,
                  barrierLabel: "NewScheduleDialog",
                  barrierDismissible: true,
                  pageBuilder: (c, _, __) {
                    return const Center(
                      child: NewScheduleDialog(),
                    );
                  });

              // _addDataSource(ref);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SfCalendar(
              onSelectionChanged: (calendarSelectionDetails) {},
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
              dataSource: ScheduleItemSource(state.items),
              monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
            ),
          )),
      error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
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
  }
}
