// ignore_for_file: avoid_init_to_null

import 'dart:math';
import 'dart:ui';

import 'package:all_in_one/llm/template_editor/components/connector_painter.dart';
import 'package:all_in_one/llm/template_editor/notifiers/chain_flow_notifier.dart';
import 'package:all_in_one/llm/template_editor/models/chain_flow_state.dart';
import 'package:all_in_one/src/rust/api/llm_plugin_api.dart';
import 'package:all_in_one/src/rust/llm/app_flowy_model.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
// import 'package:langchain_lib/models/template_item.dart';

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
                                        .getBounds(),
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
                                        .mapIndexed(
                                            (i, e) => _itemBuilder(e.$1))
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
                      child: ref
                              .watch(chainFlowProvider)
                              .items
                              .flowItems
                              .isEmpty
                          ? const SizedBox.shrink()
                          : Tags(
                              itemCount: ref
                                  .watch(chainFlowProvider)
                                  .items
                                  .connections
                                  .length,
                              itemBuilder: (int index) {
                                final item = ref
                                    .watch(chainFlowProvider)
                                    .items
                                    .getConnections()
                                    .elementAt(index);
                                final vstr = item.toString();
                                return ItemTags(
                                  removeButton: ItemTagsRemoveButton(
                                      onRemoved: () {
                                        ref
                                            .read(chainFlowProvider.notifier)
                                            .removeConnection(ref
                                                .read(chainFlowProvider)
                                                .items
                                                .connections[index]);
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

class ChainFlowDesigner extends ConsumerStatefulWidget {
  const ChainFlowDesigner({super.key});

  @override
  ConsumerState<ChainFlowDesigner> createState() => _ChainFlowDesignerState();
}

class _ChainFlowDesignerState extends ConsumerState<ChainFlowDesigner> {
  Dashboard dashboard = Dashboard();
  List<
      (
        /*uuid*/ String,
        /*prompt*/ String,
        /*type*/ AttributeType,
        /* extra, sql,path */ String?
      )> items = [];

  init() async {
    final flowItems = ref.read(chainFlowProvider).items.flowItems;

    final extractedItems =
        await templateToPrompts(template: ref.read(chainFlowProvider).content);
    // print("extractedItems.length ${extractedItems.length}");
    for (int i = 0; i < extractedItems.length; i++) {
      final element = FlowElement(
          position: Offset(100 + 200.0 * i, 100),
          size: const Size(100, 50),
          text:
              extractedItems[i].$1.replaceFirst("{{", "").replaceAll("}}", ""),
          kind: ElementKind.oval,
          textSize: 14,
          textIsBold: false,
          handlers: [
            if (i != 0) Handler.leftCenter,
            if (i != items.length - 1) Handler.rightCenter,
          ]);

      final fitem =
          flowItems.where((v) => v.content == extractedItems[i].$1).firstOrNull;

      // print("fitem ${fitem}");

      if (fitem != null) {
        element.setId(fitem.uuid);
      }

      items.add((
        element.id,
        extractedItems[i].$1,
        extractedItems[i].$2,
        extractedItems[i].$3,
      ));

      dashboard.addElement(element, notify: i == items.length - 1);
    }

    ref.read(chainFlowProvider.notifier).addAllItems(items
        .mapIndexed((index, v) => FlowItem(
            content: v.$2, uuid: v.$1, type: v.$3, extra: v.$4, index: index))
        .toList());

    final connections = ref.read(chainFlowProvider).items.connections;

    for (final c in connections) {
      final srcElement =
          dashboard.elements.where((v) => v.id == c.$1).firstOrNull;
      final destElement =
          dashboard.elements.where((v) => v.id == c.$2).firstOrNull;

      if (srcElement != null && destElement != null) {
        dashboard.addNextById(srcElement, c.$2, ArrowParams());
      } else {
        ref.read(chainFlowProvider.notifier).removeConnection(c);
      }
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
            onConnectionCreated: (sourceId, destId) {
              return ref
                  .read(chainFlowProvider.notifier)
                  .addConnection(sourceId, destId);
            },
            onLineLongPressed:
                (context, clickPosition, srcElement, destElement) {
              dashboard.removeConnectionByElements(srcElement, destElement);
            },
          ),
        ),
      ),
    );
  }
}
