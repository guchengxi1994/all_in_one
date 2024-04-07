import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleTypeState {
  List<CalendarView> switches;
  CalendarView current;

  ScheduleTypeState(
      {this.current = CalendarView.schedule,
      this.switches = CalendarView.values});
}

extension ToString on CalendarView {
  String toStr() {
    switch (this) {
      case CalendarView.day:
        return "day";
      case CalendarView.month:
        return "month";
      case CalendarView.schedule:
        return "schedule";
      case CalendarView.timelineDay:
        return "timelineDay";
      case CalendarView.timelineMonth:
        return "timelineMonth";
      case CalendarView.timelineWeek:
        return "timelineWeek";
      case CalendarView.timelineWorkWeek:
        return "timelineWorkWeek";
      case CalendarView.week:
        return "week";
      case CalendarView.workWeek:
        return "workWeek";
      default:
        return "schedule";
    }
  }
}
