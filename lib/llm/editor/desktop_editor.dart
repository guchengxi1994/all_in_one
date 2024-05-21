import 'package:all_in_one/llm/plugins/chat_db/sql_toolbar_item.dart';
import 'package:all_in_one/llm/plugins/chat_file/file_toolbar_item.dart';
import 'package:all_in_one/llm/plugins/chat_file/group.dart';
import 'package:all_in_one/llm/editor/components/show_ai_menu.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../template_editor/components/mark_as_template_item.dart';

class DesktopEditor extends StatefulWidget {
  const DesktopEditor({
    super.key,
    required this.editorState,
    this.textDirection = TextDirection.ltr,
    this.showTemplateFeatures = false,
  });

  final EditorState editorState;
  final TextDirection textDirection;
  final bool showTemplateFeatures;

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

  late final customItem = SelectionMenuItem(
    getName: () => "AI assistant",
    icon: (editorState, isSelected, style) =>
        const Icon(Bootstrap.robot, size: 15),
    keywords: ['AI'],
    handler: (editorState, _, __) {
      showAiMenu(editorState);
    },
  );

  late List<SelectionMenuItem> all = [
    ...standardSelectionMenuItems,
    customItem
  ];

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
        if (widget.showTemplateFeatures) markAsTemplateItem,
        linkItem,
        if (widget.showTemplateFeatures) sqlItem,
        if (widget.showTemplateFeatures) fileChatItem,
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
          characterShortcutEvents: [
            customSlashCommand(all),
            ...standardCharacterShortcutEvents,
          ],
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
              ..onTap = () async {
                final selection = Selection.single(
                  path: node.path,
                  startOffset: index,
                  endOffset: index + text.text.length,
                );
                // debugPrint('onTap: ${selection.toJson()}');

                /// TODO 重新选择文件
                final XFile? file =
                    await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

                if (file == null) {
                  return;
                }

                /// TODO
                /// select file
                await editorState.formatDelta(selection, {
                  "file": file.path,
                });
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
