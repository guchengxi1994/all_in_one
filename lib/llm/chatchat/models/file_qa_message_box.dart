import 'package:all_in_one/common/color_utils.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'message_box.dart';

typedef OnQuestionClicked = void Function(String);

class FileQaMessageBox extends MessageBox {
  FileQaMessageBox(
      {required super.content,
      required this.prompts,
      required this.onQuestionClicked});
  final List<String> prompts;
  final OnQuestionClicked onQuestionClicked;

  @override
  Widget toWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ColorUtil.getColorFromHex('#f5f5f5'),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: MarkdownBlock(data: content),
            ),
            const SizedBox(
              height: 20,
            ),
            Material(
              color: Colors.white,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: prompts
                          .mapIndexed((i, e) => InkWell(
                                onTap: () {
                                  onQuestionClicked(e);
                                },
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text("${i + 1}. $e"),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
