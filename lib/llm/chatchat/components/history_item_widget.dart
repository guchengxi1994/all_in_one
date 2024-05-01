import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history_list.dart';

class HistoryList extends ConsumerWidget {
  const HistoryList({super.key, required this.llmType, this.bottom});
  final LLMType llmType;
  final Widget? bottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(historyProvider(llmType));

    return Container(
      width: 300,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(255, 237, 232, 236),
            Color.fromARGB(255, 221, 221, 245)
          ])),
      padding: const EdgeInsets.all(10),
      child: Builder(builder: (c) {
        return switch (notifier) {
          AsyncValue<HistoryState>(:final value?) => Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: value.history.length,
                        itemBuilder: (c, i) {
                          return HistoryListWidget(
                            history: value.history[i],
                            llmType: llmType,
                          );
                        })),
                bottom ?? const SizedBox()
              ],
            ),
          _ => const Center(
              child: CircularProgressIndicator(),
            ),
        };
      }),
    );
  }
}
