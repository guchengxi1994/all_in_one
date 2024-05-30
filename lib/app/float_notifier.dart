import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  changeState() {
    state = !state;
  }
}

final floatProvider = NotifierProvider<FloatNotifier, bool>(
  () => FloatNotifier(),
);
