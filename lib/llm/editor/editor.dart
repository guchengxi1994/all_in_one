import 'package:all_in_one/llm/editor/models/datasource.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

import 'desktop_editor.dart';

class Editor extends StatefulWidget {
  const Editor(
      {super.key,
      required this.datasource,
      required this.onEditorStateChange,
      this.editorStyle,
      this.textDirection = TextDirection.ltr,
      required this.showTemplateFeatures});

  final Datasource datasource;
  final EditorStyle? editorStyle;
  final void Function(EditorState editorState) onEditorStateChange;

  final TextDirection textDirection;
  final bool showTemplateFeatures;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  bool isInitialized = false;

  EditorState? editorState;
  WordCountService? wordCountService;

  @override
  void didUpdateWidget(covariant Editor oldWidget) {
    if (oldWidget.datasource.data != widget.datasource.data) {
      editorState = null;
      isInitialized = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  int wordCount = 0;
  int charCount = 0;

  int selectedWordCount = 0;
  int selectedCharCount = 0;

  void registerWordCounter() {
    wordCountService?.removeListener(onWordCountUpdate);
    wordCountService?.dispose();

    wordCountService = WordCountService(editorState: editorState!)..register();
    wordCountService!.addListener(onWordCountUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onWordCountUpdate();
    });
  }

  void onWordCountUpdate() {
    setState(() {
      wordCount = wordCountService!.documentCounters.wordCount;
      charCount = wordCountService!.documentCounters.charCount;
      selectedWordCount = wordCountService!.selectionCounters.wordCount;
      selectedCharCount = wordCountService!.selectionCounters.charCount;
    });
  }

  @override
  void dispose() {
    if (mounted) {
      try {
        editorState?.dispose();
      } catch (_) {}
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColoredBox(
          color: Colors.white,
          child: Builder(
            builder: (context) {
              if (!isInitialized || editorState == null) {
                isInitialized = true;
                EditorState editorState = EditorState(
                  document: widget.datasource.content == ""
                      ? Document.blank(withInitialText: true)
                      : widget.datasource.toDocument(),
                );

                editorState.logConfiguration
                  ..handler = debugPrint
                  ..level = LogLevel.off;

                editorState.transactionStream.listen((event) {
                  if (event.$1 == TransactionTime.after) {
                    widget.onEditorStateChange(editorState);
                  }
                });

                widget.onEditorStateChange(editorState);

                this.editorState = editorState;
                registerWordCounter();
              }

              return DesktopEditor(
                editorState: editorState!,
                textDirection: widget.textDirection,
                showTemplateFeatures: widget.showTemplateFeatures,
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8),
                bottomLeft: PlatformExtension.isMobile
                    ? const Radius.circular(8)
                    : Radius.zero,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Word Count: $wordCount  |  Character Count: $charCount',
                  style: const TextStyle(fontSize: 11),
                ),
                if (!(editorState?.selection?.isCollapsed ?? true))
                  Text(
                    '(In-selection) Word Count: $selectedWordCount  |  Character Count: $selectedCharCount',
                    style: const TextStyle(fontSize: 11),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
