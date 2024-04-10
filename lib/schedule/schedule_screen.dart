import 'package:all_in_one/isar/schedule.dart';
import 'package:all_in_one/schedule/components/modify_schedule_dialog.dart';
import 'package:all_in_one/schedule/models/new_schedule_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'components/new_schedule_dialog.dart';
import 'notifier/schedule_notifier.dart';

// ignore: must_be_immutable
class ScheduleScreen extends ConsumerWidget {
  ScheduleScreen({super.key});

  final CalendarController _controller = CalendarController();
  BuiltList<DateTime> lastRepaint = BuiltList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(scheduleProvider);

    // print("repaint.......................");

    return notifier.when(
      data: (state) => Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              final NewScheduleModel? r = await showGeneralDialog(
                  context: context,
                  barrierLabel: "NewScheduleDialog",
                  barrierDismissible: true,
                  pageBuilder: (c, _, __) {
                    return const Center(
                      child: NewScheduleDialog(),
                    );
                  });

              if (r != null) {
                ref.read(scheduleProvider.notifier).addEvent2(r);
              }
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SfCalendar(
              onTap: (calendarTapDetails) async {
                if (calendarTapDetails.appointments != null) {
                  if (calendarTapDetails.appointments!.length == 1) {
                    if (calendarTapDetails.appointments![0] is ScheduleItem) {
                      // print(calendarTapDetails.appointments![0].id);
                      final ScheduleItem? r = await showGeneralDialog(
                          context: context,
                          barrierLabel: "ModifyScheduleDialog",
                          barrierDismissible: true,
                          pageBuilder: (c, _, __) {
                            return Center(
                              child: ModifyScheduleDialog(
                                item: calendarTapDetails.appointments![0],
                              ),
                            );
                          });

                      if (r != null) {
                        // print(r.color);
                        // print(r.from);
                        // print(r.to);
                        ref.read(scheduleProvider.notifier).updateSchedule(r);
                      }
                    }
                  }
                }
              },

              allowAppointmentResize: false,
              onViewChanged: (viewChangedDetails) {
                BuiltList<DateTime> current =
                    BuiltList(viewChangedDetails.visibleDates);
                if (lastRepaint != current) {
                  // print("lastRepaint is not equal to current");
                  lastRepaint = current;
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
