import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoryNotifier extends AutoDisposeNotifier<MemoryInfo?> {
  @override
  MemoryInfo? build() {
    return null;
  }

  changeState(MemoryInfo info) {
    if (info != state) {
      state = info;
    }
  }
}

final memoryProvider = AutoDisposeNotifierProvider<MemoryNotifier, MemoryInfo?>(
  () => MemoryNotifier(),
);
