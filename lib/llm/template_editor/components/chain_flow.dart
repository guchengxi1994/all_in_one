// ignore_for_file: avoid_init_to_null

import 'dart:ui';

import 'package:all_in_one/llm/template_editor/components/arc_painter.dart';
import 'package:all_in_one/llm/template_editor/notifiers/chain_flow_notifier.dart';
import 'package:all_in_one/llm/template_editor/notifiers/chain_flow_state.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChainFlow extends ConsumerStatefulWidget {
  const ChainFlow({super.key, required this.items});
  final List<String> items;

  @override
  ConsumerState<ChainFlow> createState() => _ChainFlowState();
}

class _ChainFlowState extends ConsumerState<ChainFlow> {
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();

  late double childrenHeight = 0;

  int? first = null;
  String? firstStr = null;

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller1.addListener(_scrollListener);
    childrenHeight = widget.items.length * 50;
  }

  void _scrollListener() {
    if (!controller2.hasClients) {
      return;
    }
    controller2.jumpTo(controller1.offset);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: _wrapper2(SingleChildScrollView(
                controller: controller2,
                child: CustomPaint(
                  painter: ArcPainter(
                    bounds: ref
                        .watch(chainFlowProvider)
                        .items
                        .map((e) => (
                              Offset(100, e.start * 50 + 25),
                              Offset(100, e.end * 50 + 25)
                            ))
                        .toList(),
                    radius: 50, // 圆弧的半径
                    color: Colors.blue, // 圆弧的颜色
                  ),
                  size: Size(100, childrenHeight),
                ),
              ))),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: _wrapper(SingleChildScrollView(
            controller: controller1,
            child: SizedBox(
              height: childrenHeight,
              child: Column(
                children: widget.items
                    .mapIndexed((i, e) => InkWell(
                          onTap: () {
                            if (first == null) {
                              first = i;
                              firstStr = e;
                            } else {
                              ref.read(chainFlowProvider.notifier).addItem(
                                  ChainFlowItem(
                                      end: i,
                                      endContent: e,
                                      start: first!,
                                      startContent: firstStr!));

                              first = null;
                              firstStr = null;
                            }
                          },
                          child: _itemBuilder(e),
                        ))
                    .toList(),
              ),
            ),
          ))),
        ],
      ),
    );
  }

  Widget _itemBuilder(String s) {
    return Container(
      height: 40,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppStyle.appColorLight),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AutoSizeText(
          s,
          maxLines: 1,
          style: const TextStyle(color: AppStyle.white),
        ),
      ),
    );
  }

  Widget _wrapper(Widget c) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context)
          .copyWith(scrollbars: false, dragDevices: {
        //必须设置此事件，不然无法滚动
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      }),
      child: c, //嵌套你的SingleChildScrollView组件
    );
  }

  Widget _wrapper2(Widget c) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context)
          .copyWith(scrollbars: false, dragDevices: {}),
      child: c, //嵌套你的SingleChildScrollView组件
    );
  }
}
