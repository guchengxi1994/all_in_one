import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:all_in_one/common/color_utils.dart';
import 'package:all_in_one/llm/chatchat/notifiers/message_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../chatchat_config.dart';
import 'history.dart';
import 'llm_request.dart';
import 'message_box.dart';
import 'package:markdown_widget/markdown_widget.dart';

// ignore: constant_identifier_names
const String PATTERN = "##content##";

class Prompt {
  String query;
  String name;

  Prompt({required this.query, this.name = ""});
}

typedef PromptChain = List<Prompt>;

class PromptChainBox extends MessageBox {
  PromptChainBox({required super.content, required this.chain});
  final PromptChain chain;

  final GlobalKey _globalKey = GlobalKey();

  void _capturePng() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    File file = File(
        r"D:\github_repo\llm_ui\example\build\windows\x64\runner\Debug\result.png");
    await file.writeAsBytes(byteData!.buffer.asUint8List());
  }

  @override
  Widget toWidget() {
    return RepaintBoundary(
      key: _globalKey,
      child: _PromptChainBox(
        chain: chain,
        content: content,
        onScreenShot: _capturePng,
      ),
    );
  }
}

class _PromptChainBox extends ConsumerStatefulWidget {
  const _PromptChainBox(
      {required this.chain, required this.content, required this.onScreenShot});
  final PromptChain chain;
  final String content;
  final VoidCallback? onScreenShot;

  @override
  ConsumerState<_PromptChainBox> createState() => __PromptChainBoxState();
}

class __PromptChainBoxState extends ConsumerState<_PromptChainBox> {
  late List<Widget> children = [
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
                Clipboard.setData(ClipboardData(text: lastText));
              },
              child: const Icon(
                Icons.copy,
                size: iconSize,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                if (widget.onScreenShot != null) {
                  widget.onScreenShot!();
                }
              },
              child: const Icon(
                Icons.screenshot_monitor,
                size: iconSize,
              ),
            ),
          ],
        ))
  ];
  final ChatchatConfig cfg = ChatchatConfig();

  final tocController = TocController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getResult();
    });
  }

  late String lastText = widget.content;

  Future getResult() async {
    ref.read(messageProvider.notifier).setLoading(true);
    final List<IHistory> history = [];

    for (final i in widget.chain) {
      final String query;
      if (i.query.contains(PATTERN)) {
        query = i.query.replaceFirst(PATTERN, lastText);
      } else {
        query = i.query;
      }
      children.insert(
          children.length - 1,
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 142, 171, 200),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Text(
                i.query.replaceFirst(PATTERN, ""),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ));

      // setState(() {});

      LLMRequest llmRequest = LLMRequest();
      llmRequest.history = history;
      // llmRequest.history = [];
      llmRequest.modelName = cfg.modelName;
      llmRequest.stream = false;
      llmRequest.query = query;
      llmRequest.temperature = 0;
      final r = await cfg.getLLMResponseByRequest(llmRequest);

      lastText =
          jsonDecode((r.data as String).replaceFirst("data:", ""))["text"];

      children.insert(
          children.length - 1,
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(10),
                child: (lastText.contains("```") || lastText.contains("|---"))
                    ? MarkdownBlock(
                        data: lastText,
                        config: MarkdownConfig(configs: [
                          TableConfig(
                            wrapper: (table) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // 可横向滑动
                              child: table,
                            ),
                            headerStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ]),
                      )
                    : SelectableText(lastText),
              )));
      history.add(UserHistory(content: query));
      history.add(AssistantHistory(content: lastText));
      setState(() {});
    }
    ref.read(messageProvider.notifier).setLoading(false);
  }

  static const double iconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ColorUtil.getColorFromHex('#f5f5f5'),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
