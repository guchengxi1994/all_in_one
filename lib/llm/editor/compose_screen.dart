// ignore: unused_import
import 'dart:convert';

import 'package:all_in_one/llm/editor/models/datasource.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'editor.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  late EditorState _editorState;
  late WidgetBuilder _widgetBuilder;

  @override
  void initState() {
    super.initState();

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
