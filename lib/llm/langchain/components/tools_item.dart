import 'package:all_in_one/llm/langchain/models/tool_model.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolsItem extends ConsumerStatefulWidget {
  const ToolsItem({super.key, required this.toolModel});
  final ToolModel toolModel;

  @override
  ConsumerState<ToolsItem> createState() => _ToolsItemState();
}

class _ToolsItemState extends ConsumerState<ToolsItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ref
            .read(toolProvider.notifier)
            .changeState(widget.toolModel.toMessage());
        ref.read(toolProvider.notifier).jumpTo(1);
      },
      child: FittedBox(
        child: Stack(
          children: [
            const SizedBox(
              height: 70,
              width: 200,
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: 200,
                  height: 50,
                  padding: const EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      border: Border.all(color: AppStyle.appColor),
                      boxShadow: const [
                        BoxShadow(
                          color: AppStyle.appColor,
                          offset: Offset(0, 4),
                          blurRadius: 10,
                          spreadRadius: 3,
                        )
                      ]),
                  child: Center(
                    child: Text(
                      widget.toolModel.name,
                      style: const TextStyle(fontFamily: "xing", fontSize: 20),
                    ),
                  ),
                )),
            Positioned(
                top: 0,
                left: 10,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(widget.toolModel.imgPath),
                )),
          ],
        ),
      ),
    );
  }
}
