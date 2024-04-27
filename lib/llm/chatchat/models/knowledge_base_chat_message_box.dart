import 'package:all_in_one/common/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'message_box.dart';
import 'package:markdown_widget/markdown_widget.dart';

class KnowledgeBaseChatMessageBox extends MessageBox {
  KnowledgeBaseChatMessageBox({required super.content, required this.docs});

  bool isDone = false;
  static const double iconSize = 20;
  List<String> docs;

  @override
  Widget toWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ColorUtil.getColorFromHex('#f5f5f5'),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                offset: const Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 5,
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: MarkdownBlock(data: content),
            ),
            if (docs.isNotEmpty)
              Material(
                child: ExpansionTile(
                  title: const Text("出处"),
                  children: docs
                      .map((e) => Align(
                            alignment: Alignment.centerLeft,
                            child: MarkdownBlock(data: e),
                          ))
                      .toList(),
                ),
              ),
            Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.thumb_up_outlined,
                        size: iconSize,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.thumb_down_outlined,
                        size: iconSize,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: content));
                      },
                      child: const Icon(
                        Icons.copy,
                        size: iconSize,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
