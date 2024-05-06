import 'package:all_in_one/llm/langchain/models/tool_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolNotifier extends Notifier<ToolModel?> {
  final PageController controller = PageController();

  @override
  ToolModel? build() {
    return null;
  }

  changeState(ToolModel? model) {
    state = model;

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

final toolProvider = NotifierProvider<ToolNotifier, ToolModel?>(
  () => ToolNotifier(),
);
