import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CpuNotifier extends AutoDisposeNotifier<double> {
  @override
  double build() {
    return 0;
  }

  changeState(CpuInfo info) {
    if (info.current != state) {
      state = info.current;
    }
  }
}

final cpuProvider = AutoDisposeNotifierProvider<CpuNotifier, double>(
  () => CpuNotifier(),
);
