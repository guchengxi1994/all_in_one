import 'package:all_in_one/llm/plugins/chat_db/sql_toolbar_item.dart';
import 'package:all_in_one/llm/plugins/chat_file/file_toolbar_item.dart';
import 'package:all_in_one/llm/template_editor/models/datasource.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  const Editor({
    super.key,
    required this.datasource,
    required this.onEditorStateChange,
    this.editorStyle,
    this.textDirection = TextDirection.ltr,
  });

  final Datasource datasource;
  final EditorStyle? editorStyle;
  final void Function(EditorState editorState) onEditorStateChange;

  final TextDirection textDirection;

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
                  document: widget.datasource.toDocument(),
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

class DesktopEditor extends StatefulWidget {
  const DesktopEditor({
    super.key,
    required this.editorState,
    this.textDirection = TextDirection.ltr,
  });

  final EditorState editorState;
  final TextDirection textDirection;

  @override
  State<DesktopEditor> createState() => _DesktopEditorState();
}

class _DesktopEditorState extends State<DesktopEditor> {
  EditorState get editorState => widget.editorState;

  late final EditorScrollController editorScrollController;

  late EditorStyle editorStyle;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;
  late List<CommandShortcutEvent> commandShortcuts;

  @override
  void initState() {
    super.initState();

    editorScrollController = EditorScrollController(
      editorState: editorState,
      shrinkWrap: false,
    );

    editorStyle = _buildDesktopEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
    commandShortcuts = _buildCommandShortcuts();
  }

  @override
  void dispose() {
    editorScrollController.dispose();
    editorState.dispose();

    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();

    editorStyle = _buildDesktopEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
    commandShortcuts = _buildCommandShortcuts();
  }

  @override
  Widget build(BuildContext context) {
    assert(PlatformExtension.isDesktopOrWeb);
    return FloatingToolbar(
      items: [
        paragraphItem,
        ...headingItems,
        ...markdownFormatItems,
        quoteItem,
        bulletedListItem,
        numberedListItem,
        linkItem,
        sqlItem,
        fileChatItem,
        buildTextColorItem(),
        buildHighlightColorItem(),
        ...textDirectionItems,
        ...alignmentItems,
      ],
      editorState: editorState,
      textDirection: widget.textDirection,
      editorScrollController: editorScrollController,
      child: Directionality(
        textDirection: widget.textDirection,
        child: AppFlowyEditor(
          editorState: editorState,
          editorScrollController: editorScrollController,
          blockComponentBuilders: blockComponentBuilders,
          commandShortcutEvents: commandShortcuts,
          editorStyle: editorStyle,
          enableAutoComplete: true,
          // autoCompleteTextProvider: _buildAutoCompleteTextProvider,
          header: const SizedBox(
            height: 30,
          ),
          footer: const SizedBox(
            height: 30,
          ),
        ),
      ),
    );
  }

  // showcase 1: customize the editor style.
  EditorStyle _buildDesktopEditorStyle() {
    return EditorStyle.desktop(
      cursorWidth: 2.0,
      cursorColor: Colors.blue,
      selectionColor: Colors.grey.shade300,
      padding: const EdgeInsets.symmetric(horizontal: 200.0),
      textSpanDecorator: (context, node, index, text, _, textSpan) {
        final attributes = text.attributes;
        final sql = attributes?["sql"];
        final file = attributes?["file"];
        // print("href   ${href}");
        if (sql != null) {
          return TextSpan(
            text: text.text,
            style: const TextStyle(color: Color.fromARGB(255, 7, 243, 58)),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                final selection = Selection.single(
                  path: node.path,
                  startOffset: index,
                  endOffset: index + text.text.length,
                );
                // debugPrint('onTap: ${selection.toJson()}');
                showSqlMenu(context, widget.editorState, selection, true);
              },
          );
        }

        if (file != null) {
          return TextSpan(
            text: text.text,
            style: const TextStyle(color: Colors.amber),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                final selection = Selection.single(
                  path: node.path,
                  startOffset: index,
                  endOffset: index + text.text.length,
                );
                // debugPrint('onTap: ${selection.toJson()}');

                /// TODO 重新选择文件
              },
          );
        }

        return textSpan;
      },
    );
  }

  // showcase 2: customize the block style
  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };
    // customize the image block component to show a menu
    map[ImageBlockKeys.type] = ImageBlockComponentBuilder(
      showMenu: true,
      menuBuilder: (node, _) {
        return const Positioned(
          right: 10,
          child: Text('⭐️ Here is a menu!'),
        );
      },
    );
    // customize the heading block component
    // final levelToFontSize = [
    //   30.0,
    //   26.0,
    //   22.0,
    //   18.0,
    //   16.0,
    //   14.0,
    // ];
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder();
    // customize the padding
    map.forEach((key, value) {
      value.configuration = value.configuration.copyWith(
        padding: (_) => const EdgeInsets.symmetric(vertical: 8.0),
      );
    });
    return map;
  }

  // showcase 3: customize the command shortcuts
  List<CommandShortcutEvent> _buildCommandShortcuts() {
    return [
      // customize the highlight color
      customToggleHighlightCommand(
        style: ToggleColorsStyle(
          highlightColor: Colors.orange.shade700,
        ),
      ),
      ...[
        ...standardCommandShortcutEvents
          ..removeWhere(
            (el) => el == toggleHighlightCommand,
          ),
      ],
      ...findAndReplaceCommands(
        context: context,
        localizations: FindReplaceLocalizations(
          find: 'Find',
          previousMatch: 'Previous match',
          nextMatch: 'Next match',
          close: 'Close',
          replace: 'Replace',
          replaceAll: 'Replace all',
          noResult: 'No result',
        ),
      ),
    ];
  }
}
