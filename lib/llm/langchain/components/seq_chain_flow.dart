import 'dart:convert';

import 'package:all_in_one/llm/langchain/extension.dart';
import 'package:all_in_one/llm/langchain/models/chains.dart';
import 'package:all_in_one/llm/langchain/notifiers/chain_notifier.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/src/rust/api/llm_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:star_menu/star_menu.dart';

import 'modify_chain_dialog.dart';

class FlowScreen extends ConsumerStatefulWidget {
  const FlowScreen({super.key});

  @override
  ConsumerState<FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends ConsumerState<FlowScreen> {
  Dashboard dashboard = Dashboard();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (dashboard.elements.isEmpty) {
        dashboard.addElement(FlowElement(
            position: const Offset(100, 100),
            size: const Size(100, 50),
            text: '开始',
            kind: ElementKind.oval,
            handlers: []));
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),

        // child: Container(color: Colors.amber),

        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              child: FlowChart(
                dashboard: dashboard,
                onDashboardTapped: ((context, position) {
                  debugPrint('Dashboard tapped $position');
                  _displayDashboardMenu(context, position);
                }),
                onDashboardSecondaryTapped: (context, position) {
                  debugPrint('Dashboard right clicked $position');
                  _displayDashboardMenu(context, position);
                },
                onElementPressed: (context, position, element) {
                  debugPrint('Element with "${element.text}" text pressed');
                  _displayElementMenu(context, position, element);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () => dashboard.format(),
      //     child: const Icon(Icons.center_focus_strong)),
      floatingActionButton: ExpandableFab(
        distance: 50,
        type: ExpandableFabType.side,
        children: [
          FloatingActionButton.small(
            tooltip: "format",
            heroTag: "center",
            onPressed: () {
              dashboard.format();
            },
            child: const Icon(Icons.center_focus_strong),
          ),
          FloatingActionButton.small(
            tooltip: "save",
            heroTag: null,
            child: const Icon(Icons.save),
            onPressed: () {
              final r = ref.read(chainProvider.notifier).validate();
              if (r) {
                Chains chains =
                    Chains(items: ref.read(chainProvider.notifier).items);
                final jsonStr = jsonEncode(chains.toJson());
                sequentialChainChat(jsonStr: jsonStr, query: "shoe");
              }
            },
          ),
          FloatingActionButton.small(
            tooltip: "clear all",
            heroTag: null,
            child: const Icon(Icons.clear),
            onPressed: () {
              dashboard.removeAllElements(notify: true);
            },
          ),
          FloatingActionButton.small(
            tooltip: "back",
            heroTag: null,
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(toolProvider.notifier).jumpTo(0);
            },
          ),
        ],
      ),
    );
  }

  /// Display a drop down menu when tapping on an element
  _displayElementMenu(
    BuildContext context,
    Offset position,
    FlowElement element,
  ) {
    StarMenuOverlay.displayStarMenu(
      context,
      StarMenu(
        params: StarMenuParameters(
          shape: MenuShape.linear,
          openDurationMs: 60,
          linearShapeParams: const LinearShapeParams(
            angle: 270,
            alignment: LinearAlignment.left,
            space: 10,
          ),
          onHoverScale: 1.1,
          centerOffset: position - const Offset(50, 50),
          backgroundParams: const BackgroundParams(
            backgroundColor: Colors.transparent,
          ),
          boundaryBackground: BoundaryBackground(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              boxShadow: kElevationToShadow[6],
            ),
          ),
        ),
        onItemTapped: (index, controller) {
          if (!(index == 5 || index == 2)) {
            controller.closeMenu!();
          }
        },
        items: [
          Text(
            element.text,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          InkWell(
            onTap: () async {
              final (String, ChainItem)? item = await showGeneralDialog(
                  barrierColor: Colors.transparent,
                  barrierDismissible: true,
                  barrierLabel: "modify",
                  context: context,
                  pageBuilder: (c, _, __) {
                    return Center(
                      child: ModifyChainDialog(
                        item: element,
                      ),
                    );
                  });

              if (item != null) {
                element.setText(item.$1);
                ref.read(chainProvider.notifier).updateItem(element, item.$2);
              }
            },
            child: const Text('Modify'),
          ),
          InkWell(
            onTap: () {
              final prev = element.findPrevious(dashboard.elements);
              assert(prev != null, "prev cannot be null");

              final next = dashboard.elements
                  .where((e) => e.id == element.next.firstOrNull?.destElementId)
                  .firstOrNull;

              dashboard.removeElement(element, notify: next == null);

              if (next != null && prev != null) {
                dashboard.addNextById(prev, next.id, ArrowParams());
              }

              ref.read(chainProvider.notifier).removeItem(element.id);
            },
            child: const Text('Delete'),
          ),
        ],
        parentContext: context,
      ),
    );
  }

  /// Display a linear menu for the dashboard
  /// with menu entries built with [menuEntries]
  _displayDashboardMenu(BuildContext context, Offset position) {
    StarMenuOverlay.displayStarMenu(
      context,
      StarMenu(
        params: StarMenuParameters(
          shape: MenuShape.linear,
          openDurationMs: 60,
          linearShapeParams: const LinearShapeParams(
            angle: 270,
            alignment: LinearAlignment.left,
            space: 10,
          ),
          // calculate the offset from the dashboard center
          centerOffset: position -
              Offset(
                dashboard.dashboardSize.width / 2,
                dashboard.dashboardSize.height / 2,
              ),
        ),
        onItemTapped: (index, controller) => controller.closeMenu!(),
        parentContext: context,
        items: [
          ActionChip(
              label: const Text('添加item'),
              onPressed: () {
                final flowElement = FlowElement(
                    position: position + const Offset(100, 25),
                    size: const Size(200, 50),
                    text: 'chain item',
                    kind: ElementKind.rectangle,
                    handlers: []);
                dashboard.addElement(flowElement, notify: false);
                // print(xor.id);
                dashboard.addNextById(
                    dashboard.elements[dashboard.elements.length - 2],
                    flowElement.id,
                    ArrowParams(),
                    notify: true);

                ref
                    .read(chainProvider.notifier)
                    .addItem(flowElement, ChainItem());
              }),
          ActionChip(
              label: const Text('清空'),
              onPressed: () {
                dashboard.removeAllElements();

                setState(() {});
              }),
        ],
      ),
    );
  }
}
