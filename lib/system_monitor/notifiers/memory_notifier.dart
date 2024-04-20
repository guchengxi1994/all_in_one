import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'memory_state.dart';

class MemoryNotifier extends AutoDisposeNotifier<MemoryState> {
  @override
  MemoryState build() {
    return MemoryState();
  }

  changeState(MemoryInfo info) {
    List<double> histoty = List.from(state.history)
      ..add(info.used / info.total);
    histoty =
        histoty.sublist(histoty.length - 200 < 0 ? 0 : histoty.length - 200);
    state = MemoryState(memoryInfo: info, history: histoty);
  }
}

final memoryProvider = AutoDisposeNotifierProvider<MemoryNotifier, MemoryState>(
  () => MemoryNotifier(),
);
