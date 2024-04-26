import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cpu_state.dart';

class CpuNotifier extends AutoDisposeNotifier<CpuState> {
  @override
  CpuState build() {
    return CpuState();
  }

  changeState(CpuInfo info) {
    List<double> histoty = List.from(state.history)..add(info.current);
    histoty =
        histoty.sublist(histoty.length - 200 < 0 ? 0 : histoty.length - 200);
    state = CpuState(current: info.current, history: histoty);
  }
}

final cpuProvider = AutoDisposeNotifierProvider<CpuNotifier, CpuState>(
  () => CpuNotifier(),
);
