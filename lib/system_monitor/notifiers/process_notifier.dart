import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'process_state.dart';

class ProcessNotifier extends AutoDisposeNotifier<ProcessState> {
  @override
  ProcessState build() {
    return ProcessState();
  }

  changeState(List<SoftwareCpu> cpus, List<SoftwareMemory> memories) {
    state = ProcessState(cpus: cpus, memories: memories);
  }
}

final processProvider =
    AutoDisposeNotifierProvider<ProcessNotifier, ProcessState>(
  () => ProcessNotifier(),
);
