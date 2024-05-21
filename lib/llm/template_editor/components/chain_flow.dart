// ignore_for_file: avoid_init_to_null

import 'dart:math';
import 'dart:ui';

import 'package:all_in_one/llm/template_editor/components/connector_painter.dart';
import 'package:all_in_one/llm/template_editor/notifiers/chain_flow_notifier.dart';
import 'package:all_in_one/llm/template_editor/notifiers/chain_flow_state.dart';
import 'package:all_in_one/src/rust/api/llm_api.dart';
import 'package:all_in_one/src/rust/llm/app_flowy_model.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class ChainFlow extends ConsumerStatefulWidget {
  const ChainFlow({super.key});

  @override
  ConsumerState<ChainFlow> createState() => _ChainFlowState();
}

class _ChainFlowState extends ConsumerState<ChainFlow> {
  late final ScrollController controller1 = ScrollController()
    ..addListener(_scrollListener);
  final ScrollController controller2 = ScrollController();

  late double childrenHeight = 0;
  List<(String, AttributeType, String?)> items = [];

  init() async {
    items =
        await templateToPrompts(template: ref.read(chainFlowProvider).content);
    childrenHeight = items.length * 50;
  }

  int? first = null;
  String? firstStr = null;

  void _scrollListener() {
    if (!controller2.hasClients) {
      return;
    }
    controller2.jumpTo(controller1.offset);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(),
        builder: (c, s) {
          if (s.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                  width: 400,
                  height: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 100,
                          child: _wrapper2(
                              SingleChildScrollView(
                                controller: controller2,
                                child: CustomPaint(
                                  painter: ConnectorPainter(
                                    bounds: ref
                                        .watch(chainFlowProvider)
                                        .items
                                        .map((e) => e.ids
                                            .map((ei) =>
                                                Offset(100, ei * 50 + 25))
                                            .toList())
                                        .toList(),
                                  ),
                                  size: Size(100, childrenHeight),
                                ),
                              ),
                              context)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: _wrapper(
                              SingleChildScrollView(
                                controller: controller1,
                                child: SizedBox(
                                  height: childrenHeight,
                                  child: Column(
                                    children: items
                                        .mapIndexed((i, e) => InkWell(
                                              onTap: () {
                                                if (first == null) {
                                                  first = i;
                                                  firstStr = e.$1;
                                                } else {
                                                  ref
                                                      .read(chainFlowProvider
                                                          .notifier)
                                                      .addItem(ChainFlowItem(
                                                        ids: [first!, i],
                                                        contents: [
                                                          firstStr!,
                                                          e.$1
                                                        ],
                                                      ));

                                                  first = null;
                                                  firstStr = null;
                                                }
                                              },
                                              child: _itemBuilder(e.$1),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              context)),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ref.watch(chainFlowProvider).items.isEmpty
                          ? const SizedBox.shrink()
                          : Tags(
                              itemCount:
                                  ref.watch(chainFlowProvider).items.length,
                              itemBuilder: (int index) {
                                final item = ref
                                    .watch(chainFlowProvider)
                                    .items
                                    .elementAt(index);
                                final vstr = item.toString();
                                return ItemTags(
                                  removeButton: ItemTagsRemoveButton(
                                      onRemoved: () {
                                        ref
                                            .read(chainFlowProvider.notifier)
                                            .removeItem(item);
                                        return true;
                                      },
                                      icon: Icons.delete),
                                  pressEnabled: false,
                                  title:
                                      vstr.substring(0, min(10, vstr.length)),
                                  index: index,
                                );
                              },
                            ),
                      // child: SimpleTags(
                      //   content: ref.watch(chainFlowProvider).items.map((v) {
                      //     final vstr = v.toString();
                      //     return vstr.substring(0, min(10, vstr.length));
                      //   }).toList(),
                      //   wrapSpacing: 4,
                      //   wrapRunSpacing: 4,
                      //   tagContainerPadding: const EdgeInsets.all(6),
                      //   tagTextStyle: const TextStyle(color: Colors.deepPurple),
                      //   tagIcon: InkWell(
                      //     onTap: () {},
                      //     child: const Icon(Icons.clear, size: 12),
                      //   ),
                      //   tagContainerDecoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(color: Colors.grey),
                      //     borderRadius: const BorderRadius.all(
                      //       Radius.circular(20),
                      //     ),
                      //     boxShadow: const [
                      //       BoxShadow(
                      //         color: Color.fromRGBO(139, 139, 142, 0.16),
                      //         spreadRadius: 1,
                      //         blurRadius: 1,
                      //         offset: Offset(1.75, 3.5), // c
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ))
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
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

  Widget _wrapper(Widget c, BuildContext context) {
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

  Widget _wrapper2(Widget c, BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context)
          .copyWith(scrollbars: false, dragDevices: {}),
      child: c, //嵌套你的SingleChildScrollView组件
    );
  }
}

class ChainFlowV2 extends ConsumerStatefulWidget {
  const ChainFlowV2({super.key});

  @override
  ConsumerState<ChainFlowV2> createState() => _ChainFlowV2State();
}

class _ChainFlowV2State extends ConsumerState<ChainFlowV2> {
  Dashboard dashboard = Dashboard();
  List<(String, AttributeType, String?)> items = [];

  init() async {
    items =
        await templateToPrompts(template: ref.read(chainFlowProvider).content);
    // print(items.length);
    for (int i = 0; i < items.length; i++) {
      dashboard.addElement(
          FlowElement(
              position: Offset(100 + 200.0 * i, 100),
              size: const Size(100, 50),
              text: items[i].$1.replaceFirst("{{", "").replaceAll("}}", ""),
              kind: ElementKind.oval,
              textSize: 14,
              textIsBold: false,
              handlers: [
                if (i != 0) Handler.leftCenter,
                if (i != items.length - 1) Handler.rightCenter,
              ]),
          notify: i == items.length - 1);
    }

    // print(dashboard.toJson());
  }

  // ignore: prefer_typing_uninitialized_variables
  var future;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.8 * MediaQuery.of(context).size.width,
      height: 0.8 * MediaQuery.of(context).size.height,
      child: Material(
        elevation: 10,
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: FlowChart(
            dashboard: dashboard,
            onDashboardTapped: ((context, position) {}),
            onDashboardSecondaryTapped: (context, position) {},
            onElementPressed: (context, position, element) {},
          ),
        ),
      ),
    );
  }
}
