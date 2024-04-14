import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkboardNotifier extends AutoDisposeNotifier {
  Stream<DateTime> timeStream() async* {
    while (1 == 1) {
      final datetime = DateTime.now();
      yield datetime;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  build() {}
}

final workboardProvider = AutoDisposeNotifierProvider(
  () => WorkboardNotifier(),
);
