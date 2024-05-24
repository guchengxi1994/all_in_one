import 'package:all_in_one/llm/plugins/models/mind_map_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';

const elementSize = Size(200, 50);
const elementKind = ElementKind.rectangle;
const elementFontSize = 14.0;
const Offset rootOffset = Offset(100, 100);

extension ToMindMap on Dashboard {
  loadFromMap(Map<String, dynamic> map) {
    removeAllElements(notify: false);
    MindMapData mindMapData = MindMapData.fromJson(map);
    // add root
    List<Map<String, dynamic>> flattenedOffset =
        mindMapData.flattenNodesWithOffset(rootOffset: const Offset(100, 100));

    for (final i in flattenedOffset) {
      final felement = FlowElement(
          text: i['value'] ?? "unknow",
          textSize: elementFontSize,
          size: elementSize,
          kind: elementKind,
          position: i['offset'] ?? rootOffset);
      addElement(felement);
      i['uuid'] = felement.id;
    }

    print(flattenedOffset);

    for (final i in flattenedOffset) {
      print(i['uuid']);
      if (i['subNodes'] != null) {
        _addConnection(i['uuid'], i['subNodes']);
      }
    }
  }

  _addConnection(String uuid, List<Map<String, dynamic>> maps) {
    for (final j in maps) {
      if (j['subNodes'] == null) {
        addNextById(elements.where((v) => v.id == uuid).first, j['uuid'],
            ArrowParams());
      } else {
        _addConnection(uuid, j['subNodes']);
      }
    }
  }
}

class DashboardFromMap extends StatefulWidget {
  const DashboardFromMap({super.key, required this.map});
  final Map<String, dynamic> map;

  @override
  State<DashboardFromMap> createState() => _DashboardFromMapState();
}

class _DashboardFromMapState extends State<DashboardFromMap> {
  Dashboard dashboard = Dashboard();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboard.loadFromMap(widget.map);
    });
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
            onConnectionCreated: (sourceId, destId) {},
            onLineLongPressed:
                (context, clickPosition, srcElement, destElement) {},
          ),
        ),
      ),
    );
  }
}
