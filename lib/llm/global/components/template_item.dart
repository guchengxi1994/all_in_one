import 'package:all_in_one/isar/llm_template.dart';
import 'package:all_in_one/llm/global/notifiers/template_select_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef OnTemplateSelected = void Function(int);

class TemplateItem extends ConsumerStatefulWidget {
  const TemplateItem(
      {super.key, required this.template, required this.onTemplateSelected});
  final LlmTemplate template;
  final OnTemplateSelected onTemplateSelected;

  @override
  ConsumerState<TemplateItem> createState() => _TemplateItemState();
}

class _TemplateItemState extends ConsumerState<TemplateItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    // print(ref.watch(templateSelectProvider));
    final state = ref.watch(templateSelectProvider);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onTemplateSelected(widget.template.id);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              color: isHovering
                  ? const Color.fromARGB(255, 197, 195, 227).withAlpha(100)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              SizedBox(
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.check_box,
                      color: state == widget.template.id
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Text(
                  widget.template.name,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: state == widget.template.id
                          ? Colors.blue
                          : Colors.grey),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(widget.template.templateContent,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: state == widget.template.id
                            ? Colors.blue
                            : Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
