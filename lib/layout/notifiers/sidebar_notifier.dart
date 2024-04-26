import 'package:flutter_riverpod/flutter_riverpod.dart';

class SidebarNotifier extends AutoDisposeNotifier<bool> {
  @override
  bool build() {
    return false;
  }

  changeStatus(bool b) {
    if (state != b) {
      state = b;
    }
  }
}

final sidebarProvider = AutoDisposeNotifierProvider<SidebarNotifier, bool>(
  () => SidebarNotifier(),
);
