import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/message_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryListWidget extends ConsumerStatefulWidget {
  const HistoryListWidget(
      {super.key, required this.history, required this.llmType});
  final LLMHistory history;
  final LLMType llmType;

  @override
  ConsumerState<HistoryListWidget> createState() => _HistoryListWidgetState();
}

class _HistoryListWidgetState extends ConsumerState<HistoryListWidget> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (event) {
        setState(() {
          isHovering = false;
        });
      },
      onEnter: (event) {
        setState(() {
          isHovering = true;
        });
      },
      child: InkWell(
        onTap: () {
          ref
              .read(historyProvider(widget.llmType).notifier)
              .refresh(widget.history.id);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: ref.read(historyProvider(widget.llmType)).value?.current ==
                      widget.history.id
                  ? const Color.fromARGB(255, 197, 195, 227)
                  : isHovering
                      ? const Color.fromARGB(255, 197, 195, 227).withAlpha(100)
                      : Colors.transparent),
          height: 50,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                widget.history.title ?? "",
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              )),
              const SizedBox(
                width: 10,
              ),
              if (isHovering)
                InkWell(
                  onTap: () {
                    // 删除数据
                    ref
                        .read(historyProvider(widget.llmType).notifier)
                        .delete(widget.history.id);

                    ref.read(messageProvider.notifier).refresh([]);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 58, 58, 58),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
