import 'dart:async';

import 'package:all_in_one/tool_entry/notifiers/entry_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolNotifier extends AutoDisposeAsyncNotifier<List<(String, String)>> {
  @override
  FutureOr<List<(String, String)>> build() async {
    return await ref.read(entryProvider.notifier).getOrdered();
  }
}

final toolProvider =
    AutoDisposeAsyncNotifierProvider<ToolNotifier, List<(String, String)>>(
  () => ToolNotifier(),
);
