import 'package:all_in_one/src/rust/llm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolNotifier extends Notifier<LLMMessage?> {
  final PageController controller = PageController();

  @override
  LLMMessage? build() {
    return null;
  }

  changeState(LLMMessage? message) {
    state = message;

    // if (message == null) {
    //   controller.jumpToPage(0);
    // } else {
    //   controller.jumpToPage(1);
    // }
  }

  jumpTo(int index) {
    controller.jumpToPage(index);
  }
}

final toolProvider = NotifierProvider<ToolNotifier, LLMMessage?>(
  () => ToolNotifier(),
);
