import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:all_in_one/llm/plugins/models/mind_map_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

const elementSize = Size(200, 100);
const elementKind = ElementKind.mindMap;
const elementFontSize = 14.0;
const Offset rootOffset = Offset(100, 100);

extension ToMindMap on Dashboard {
  List<(String, String)> loadFromModel(MindMapData mindMapData) {
    removeAllElements(notify: false);

    List<Map<String, dynamic>> flattenedOffset =
        mindMapData.flattenNodesWithOffset(rootOffset: const Offset(100, 100));

    for (final i in flattenedOffset) {
      final felement = FlowElement(
          text: jsonEncode({
            "node": i['value'] ?? "unknow subject",
            "description": i['description'] ?? "invalid description"
          }),
          textSize: elementFontSize,
          size: elementSize,
          kind: elementKind,
          handlers: [Handler.leftCenter, Handler.rightCenter],
          position: i['offset'] ?? rootOffset);
      felement.setId(i["uuid"]);
      addElement(felement);
      // i['uuid'] = felement.id;
    }

    // print(flattenedOffset);

    List<(String, String)> results = [];

    for (final i in flattenedOffset) {
      _addConnection(i['uuid'], i['parentUuid']);
      results.add((i['uuid'], i['description'] ?? ""));
    }

    return results;
  }

  _addConnection(String uuid, String? parentUuid) {
    if (parentUuid == null || parentUuid == "") {
      return;
    }
    final parentElement = elements.where((v) => v.id == parentUuid).firstOrNull;
    if (parentElement == null) {
      return;
    }
    addNextById(parentElement, uuid, ArrowParams());
  }
}

typedef OnAddingToEditor = void Function(/*saved image path*/ String);

class DashboardFromMap extends StatefulWidget {
  const DashboardFromMap(
      {super.key, required this.mindMapData, required this.onAddingToEditor});
  final MindMapData mindMapData;
  final OnAddingToEditor onAddingToEditor;

  @override
  State<DashboardFromMap> createState() => _DashboardFromMapState();
}

class _DashboardFromMapState extends State<DashboardFromMap> {
  Dashboard dashboard = Dashboard();

  late List<(String, String)> descs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      descs = dashboard.loadFromModel(widget.mindMapData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          key: globalKey,
          child: SizedBox(
            width: 0.8 * MediaQuery.of(context).size.width,
            height: 0.8 * MediaQuery.of(context).size.height,
            child: Material(
              elevation: 10,
              child: Container(
                constraints: const BoxConstraints.expand(),
                child: FlowChart(
                  dashboard: dashboard,
                  onDashboardTapped: ((context, position) {}),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            right: 20,
            bottom: 20,
            child: Tooltip(
              message: "Add to editor",
              child: InkWell(
                onTap: () {
                  _capturePng().then((v) {
                    if (v != null) {
                      widget.onAddingToEditor(v);
                    }
                  });
                },
                child: const Icon(Icons.add_box),
              ),
            ))
      ],
    );
  }

  GlobalKey globalKey = GlobalKey();

  Future<String?> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final dir = await getApplicationSupportDirectory();
      final savePath = "${dir.path}/${const Uuid().v4()}.png";

      final imgBytes = byteData.buffer.asUint8List();
      File file = File(savePath);
      file.writeAsBytes(imgBytes);
      return savePath;
    }
    return null;
  }
}
