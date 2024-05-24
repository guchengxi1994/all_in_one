// ignore: unused_import
import 'dart:convert';

import 'package:all_in_one/common/toast_utils.dart';
import 'package:all_in_one/llm/editor/models/datasource.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/llm/plugins/mind_map.dart';
import 'package:all_in_one/llm/plugins/models/mind_map_model.dart';
import 'package:all_in_one/llm/template_editor/extension.dart';
import 'package:all_in_one/src/rust/api/llm_plugin_api.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'editor.dart';
import 'notifiers/editor_notifier.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  // ignore: unused_field
  late EditorState _editorState;
  late WidgetBuilder _widgetBuilder;
  final uuid = const Uuid();
  late String result = "";

  late Stream<String> toMapStream = mindMapStream();

  @override
  void initState() {
    super.initState();

    toMapStream.listen((event) {
      if (event == "!over!") {
        result = result.replaceAll("\n", "");
        try {
          MindMapData data = MindMapData.fromJson(jsonDecode(result));
          showGeneralDialog(
              barrierColor: Colors.transparent,
              barrierLabel: "dashboard from map",
              barrierDismissible: true,
              context: context,
              pageBuilder: (c, _, __) {
                return Center(
                  child: DashboardFromMap(
                    mindMapData: data,
                    onAddingToEditor: (p0) {
                      _editorState.selection ??= Selection.single(
                          path: [0], startOffset: 0, endOffset: 0);
                      _editorState.insertImageNode(p0);
                    },
                  ),
                );
              });
        } catch (_) {
          return;
        }
      } else {
        result += event;
      }
    });

    _widgetBuilder = (context) => Editor(
          // jsonString: Future(() => _jsonString),
          datasource: Datasource(type: DatasourceType.json, content: ""),
          onEditorStateChange: (editorState) {
            _editorState = editorState;
          },
          showTemplateFeatures: false,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 50,
        type: ExpandableFabType.side,
        children: [
          FloatingActionButton.small(
            tooltip: "save article",
            heroTag: "save",
            onPressed: () {
              ref
                  .read(editorNotifierProvider.notifier)
                  .createArticle(
                      _editorState.toStr2().split("\n").firstOrNull ??
                          "unknow-${uuid.v4()}",
                      jsonEncode(_editorState.document.toJson()))
                  .then((_) {
                ToastUtils.sucess(context, title: "Insert success");
              }, onError: (_) {
                ToastUtils.error(context, title: "Insert error");
              });
            },
            child: const Icon(Icons.save),
          ),
          FloatingActionButton.small(
              tooltip: "mind-map",
              heroTag: "",
              onPressed: () {
                final s = _editorState.toStr2();

                result = "";
                textToMindMap(s: s);
              },
              child: const Icon(Icons.map)),
          FloatingActionButton.small(
            tooltip: "back",
            heroTag: "",
            onPressed: () {
              ref.read(toolProvider.notifier).jumpTo(0);
            },
            child: const Icon(Icons.chevron_left),
          ),
        ],
      ),
      extendBodyBehindAppBar: PlatformExtension.isDesktopOrWeb,
      body: SafeArea(child: _widgetBuilder(context)),
    );
  }
}
