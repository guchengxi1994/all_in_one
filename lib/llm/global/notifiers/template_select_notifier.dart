import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplateSelectNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() {
    return -1;
  }

  changeState(int i) {
    if (state != i) {
      state = i;
    } else {
      state = -1;
    }
  }
}

final templateSelectProvider =
    AutoDisposeNotifierProvider<TemplateSelectNotifier, int>(
  () => TemplateSelectNotifier(),
);
