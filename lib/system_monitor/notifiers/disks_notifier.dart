import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisksNotifier extends AutoDisposeNotifier<List<MountedInfo>> {
  @override
  List<MountedInfo> build() {
    return [];
  }

  changeState(List<MountedInfo> list) {
    state = List.from(list);
  }
}

final disksProvider =
    AutoDisposeNotifierProvider<DisksNotifier, List<MountedInfo>>(
  () => DisksNotifier(),
);
