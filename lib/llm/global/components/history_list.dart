import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_state.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history_item_widget.dart';

class HistoryList extends ConsumerStatefulWidget {
  const HistoryList({super.key, required this.llmType, this.bottom});
  final LLMType llmType;
  final Widget? bottom;

  @override
  ConsumerState<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends ConsumerState<HistoryList> {
  final TextEditingController textEditingController = TextEditingController();
  // late List<String> suggestions = [];
  late LLMType llmType = widget.llmType;
  late Widget? bottom = widget.bottom;

  @override
  Widget build(BuildContext context) {
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
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: FieldSuggestion<String>(
                      textController: textEditingController,
                      inputDecoration: AppStyle.inputDecoration,
                      itemBuilder: (c, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            child: ListTile(
                              title: Text(value.suggestions[index]),
                              // subtitle: Text(suggestions[index].email!),
                            ),
                          ),
                        );
                      },
                      // textController: textController,
                      suggestions: value.suggestions,
                      search: (item, input) {
                        // Disable box, if item selected.
                        if (item == input) return false;

                        return item
                            .toString()
                            .toLowerCase()
                            .contains(input.toLowerCase());
                      }),
                ),
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
