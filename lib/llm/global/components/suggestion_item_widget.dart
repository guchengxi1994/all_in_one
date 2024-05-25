import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_notifier.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuggestionItemWidget extends ConsumerStatefulWidget {
  const SuggestionItemWidget(
      {super.key,
      required this.history,
      required this.llmType,
      required this.boxController,
      required this.chatTag});
  final LLMHistory history;
  final LLMType llmType;
  final String chatTag;
  final BoxController boxController;

  @override
  ConsumerState<SuggestionItemWidget> createState() =>
      _SuggestionItemWidgetState();
}

class _SuggestionItemWidgetState extends ConsumerState<SuggestionItemWidget> {
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
          widget.boxController.close?.call();
        },
        child: Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isHovering
                  ? const Color.fromARGB(255, 197, 195, 227).withAlpha(100)
                  : Colors.transparent),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.history.title ?? "",
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(widget.history.createAt)
                        .toIso8601String()
                        .split("T")
                        .first,
                    style: const TextStyle(
                        color: AppStyle.appColorLight, fontSize: 12),
                  ),
                ],
              )),
              if (ref
                      .read(historyProvider((widget.llmType, widget.chatTag)))
                      .value
                      ?.current ==
                  widget.history.id)
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
