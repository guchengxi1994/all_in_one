// ignore_for_file: unused_field, avoid_init_to_null, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/llm/template_editor/components/chain_flow.dart';
import 'package:all_in_one/llm/template_editor/extension.dart';
import 'package:all_in_one/llm/template_editor/models/datasource.dart';
import 'package:all_in_one/llm/template_editor/notifiers/chain_flow_notifier.dart';
import 'package:all_in_one/src/rust/api/llm_api.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import 'components/editor.dart';

/* eg.
   {{ 帮我生成一份rust学习清单 }}
   {{ 根据清单内容梳理难点 }}
*/
class TemplateEditor extends ConsumerStatefulWidget {
  const TemplateEditor({super.key});

  @override
  ConsumerState<TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends ConsumerState<TemplateEditor> {
  late EditorState _editorState;
  late String _jsonString;
  late WidgetBuilder _widgetBuilder;

  final stream = templateMessageStream();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(chainFlowProvider.notifier).clear();
    });

    _jsonString = jsonEncode({
      "document": {
        "type": "page",
        "children": [
          {
            "type": "heading",
            "data": {
              "level": 2,
              "delta": [
                {
                  "insert": "👋 欢迎使用模板编辑器",
                  "attributes": {"bold": true, "italic": false}
                },
              ],
              "align": "center"
            }
          }
        ]
      }
    });
    _widgetBuilder = (context) => Editor(
          // jsonString: Future(() => _jsonString),
          datasource:
              Datasource(type: DatasourceType.json, content: _jsonString),
          onEditorStateChange: (editorState) {
            _editorState = editorState;
          },
        );

    /// FIXME
    /// 返回的都是全文，
    /// 如果是stream的返回方式
    /// 最好每次只返回最后的内容，不需要全文返回
    stream.listen((event) {
      // print(event.response);
      for (final i in _editorState.document.root.children) {
        if ((i.attributes['delta'] as List).isNotEmpty) {
          // Node? existsNode = null;
          Map<String, dynamic>? map = null;
          for (int j = 0; j < i.attributes['delta'].length; j++) {
            if (i.attributes['delta'][j]["insert"] != null &&
                i.attributes['delta'][j]["insert"].contains(event.prompt)) {
              map = i.attributes;
              map['delta'][j]['insert'] = event.prompt + event.response;
            }
          }
          if (map != null) {
            i.updateAttributes(map);
          }
        }
      }
    });
  }

  final GlobalKey<ScaffoldState> key = GlobalKey();
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      endDrawer: const ChainFlow(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 50,
        type: ExpandableFabType.side,
        children: [
          FloatingActionButton.small(
            tooltip: "chain viewer",
            heroTag: "",
            onPressed: () {
              if (key.currentState!.isEndDrawerOpen) {
                key.currentState!.closeEndDrawer();
              } else {
                ref
                    .read(chainFlowProvider.notifier)
                    .changeContent(jsonEncode(_editorState.document.toJson()));
                key.currentState!.openEndDrawer();
              }
            },
            child: const Icon(Bootstrap.view_list),
          ),
          FloatingActionButton.small(
            tooltip: "save",
            heroTag: "",
            onPressed: () {},
            child: const Icon(Bootstrap.download),
          ),
          FloatingActionButton.small(
            tooltip: "test-seq-chain",
            heroTag: null,
            child: const Icon(Bootstrap.file_word),
            onPressed: () async {
              ref
                  .read(chainFlowProvider.notifier)
                  .changeContent(jsonEncode(_editorState.document.toJson()));
              final l = await ref.read(chainFlowProvider.notifier).toRust();

              // for (final i in _editorState.document.root.children) {
              //   print(i.attributes['delta'].runtimeType);
              // }

              generateFromTemplate(v: l).then((value) async {
                final md = await optimizeDoc(s: _editorState.toStr());
                setState(
                  () {
                    _widgetBuilder = (context) => Editor(
                          datasource: Datasource(
                            type: DatasourceType.markdown,
                            content: md,
                          ),
                          onEditorStateChange: (editorState) {
                            _editorState = editorState;
                          },
                        );
                  },
                );
              });
            },
          ),
          FloatingActionButton.small(
            tooltip: "test-chain",
            heroTag: null,
            child: const Icon(Bootstrap.activity),
            onPressed: () async {
              String s = jsonEncode(_editorState.document.toJson());
              final res = await templateRenderer(template: s);
              if (res != null) {
                _jsonString = jsonEncode(jsonDecode(res));

                setState(() {
                  _editorState =
                      EditorState(document: Document.fromJson(jsonDecode(res)));
                });
              }
            },
          ),
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
