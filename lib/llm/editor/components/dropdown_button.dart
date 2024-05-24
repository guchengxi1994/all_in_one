import 'package:all_in_one/llm/editor/notifiers/ai_generate_config_notifier.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StyleDropdownButton extends ConsumerStatefulWidget {
  const StyleDropdownButton(
      {super.key, required this.options, required this.label});
  final List<String> options;
  final String label;

  @override
  ConsumerState<StyleDropdownButton> createState() =>
      StyleDropdownButtonState();
}

class StyleDropdownButtonState extends ConsumerState<StyleDropdownButton> {
  late String selected = "";
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.label == "语气") {
      selected = ref.watch(aiGenerateConfigNotifierProvider).tone;
    } else if (widget.label == "字数") {
      selected = ref.watch(aiGenerateConfigNotifierProvider).length;
    } else {
      selected = ref.watch(aiGenerateConfigNotifierProvider).lang;
    }

    return Material(
      borderRadius: BorderRadius.circular(15),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
            onMenuStateChange: (isOpen) {
              setState(() {
                expanded = isOpen;
              });
            },
            customButton: Container(
              padding: const EdgeInsets.all(4),
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[400]!)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(color: Colors.grey[400]!, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selected,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Icon(expanded ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 20, color: Colors.grey)
                    ],
                  )
                ],
              ),
            ),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: Colors.redAccent,
              ),
              elevation: 2,
            ),
            onChanged: (value) {
              if (value != null) {
                // setState(() {
                //   selected = value;
                // });

                if (widget.label == "语气") {
                  ref
                      .read(aiGenerateConfigNotifierProvider.notifier)
                      .changeTone(value);
                } else if (widget.label == "字数") {
                  ref
                      .read(aiGenerateConfigNotifierProvider.notifier)
                      .changeLength(value);
                } else {
                  ref
                      .read(aiGenerateConfigNotifierProvider.notifier)
                      .changeLang(value);
                }
              }
            },
            items: widget.options
                .map((v) => DropdownMenuItem<String>(value: v, child: Text(v)))
                .toList()),
      ),
    );
  }
}
