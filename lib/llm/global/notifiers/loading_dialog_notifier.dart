import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LoadingDialogState { eval, format, optimize, done }

class LoadingDialogNotifier extends Notifier<LoadingDialogState> {
  @override
  LoadingDialogState build() {
    return LoadingDialogState.format;
  }

  changeState(LoadingDialogState s) {
    if (state != s) {
      state = s;
    }
  }
}

final loadingDialogProvider =
    NotifierProvider<LoadingDialogNotifier, LoadingDialogState>(
  () => LoadingDialogNotifier(),
);
