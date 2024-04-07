import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'schedule_type_state.dart';

class ScheduleTypeNotifier extends AutoDisposeNotifier<ScheduleTypeState> {
  @override
  ScheduleTypeState build() {
    return ScheduleTypeState();
  }
}

final scheduleTypeProvider =
    AutoDisposeNotifierProvider<ScheduleTypeNotifier, ScheduleTypeState>(
  () => ScheduleTypeNotifier(),
);
