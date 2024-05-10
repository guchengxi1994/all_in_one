// ignore_for_file: unused_field

import 'dart:convert';

import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/llm/template_editor/components/chain_flow.dart';
import 'package:all_in_one/src/rust/api/llm_api.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import 'components/editor.dart';

class TemplateEditor extends ConsumerStatefulWidget {
  const TemplateEditor({super.key});

  @override
  ConsumerState<TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends ConsumerState<TemplateEditor> {
  late EditorState _editorState;
  late String _jsonString;
  late WidgetBuilder _widgetBuilder;

  @override
  void initState() {
    super.initState();
    _jsonString = jsonEncode({
      "document": {
        "type": "page",
        "children": [
          {
            "type": "heading",
            "data": {
              "level": 2,
              "delta": [
                {"insert": "👋 "},
                {
                  "insert": "Welcome to",
                  "attributes": {"bold": true, "italic": false}
                },
                {"insert": " "},
                {
                  "insert": "Template editor",
                  "attributes": {"bold": true, "italic": true}
                }
              ],
              "align": "center"
            }
          }
        ]
      }
    });
    _widgetBuilder = (context) => Editor(
          jsonString: Future(() => _jsonString),
          onEditorStateChange: (editorState) {
            _editorState = editorState;
          },
        );
  }

  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      endDrawer:
          ChainFlow(items: List.generate(40, (index) => index.toString())),
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
                key.currentState!.openEndDrawer();
              }
            },
            child: const Icon(Bootstrap.view_list),
          ),
          FloatingActionButton.small(
            tooltip: "save",
            heroTag: "",
            onPressed: () {
              print(jsonEncode(_editorState.document.toJson()));
            },
            child: const Icon(Bootstrap.download),
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
