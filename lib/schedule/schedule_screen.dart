import 'package:all_in_one/isar/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'components/new_schedule_dialog.dart';
import 'notifier/schedule_notifier.dart';

// ignore: must_be_immutable
class ScheduleScreen extends ConsumerWidget {
  ScheduleScreen({super.key});

  final CalendarController _controller = CalendarController();
  List<DateTime> lastRepaint = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(scheduleProvider);

    // print("repaint.......................");

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
              onViewChanged: (viewChangedDetails) {
                if (lastRepaint.length !=
                    viewChangedDetails.visibleDates.length) {
                  lastRepaint = viewChangedDetails.visibleDates;
                  Future(() => ref
                      .read(scheduleProvider.notifier)
                      .onViewChange(viewChangedDetails.visibleDates));
                  return;
                }

                bool needsRepaint = false;
                for (int i = 0; i < lastRepaint.length; i++) {
                  if (lastRepaint[i] != viewChangedDetails.visibleDates[i]) {
                    needsRepaint = true;
                  }
                }

                if (needsRepaint) {
                  lastRepaint = viewChangedDetails.visibleDates;
                  Future(() => ref
                      .read(scheduleProvider.notifier)
                      .onViewChange(viewChangedDetails.visibleDates));
                  return;
                }
              },
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
}
