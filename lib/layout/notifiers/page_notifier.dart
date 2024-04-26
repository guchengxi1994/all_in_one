import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageNotifier extends AutoDisposeNotifier<int> {
  final PageController pageController = PageController();

  @override
  int build() {
    return 0;
  }

  changePage(int index) {
    if (state != index) {
      state = index;
      pageController.jumpToPage(index);
    }
  }
}

final pageProvider = AutoDisposeNotifierProvider<PageNotifier, int>(
  () => PageNotifier(),
);
