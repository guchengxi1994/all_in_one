import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

final markAsTemplateItem = ToolbarItem(
  id: 'editor.template',
  group: 4,
  isActive: onlyShowInSingleSelectionAndTextType,
  builder: (context, editorState, highlightColor, iconColor) {
    final selection = editorState.selection!;
    final nodes = editorState.getNodesInSelection(selection);
    // final isFile = nodes.allSatisfyInSelection(selection, (delta) {
    //   return delta.everyAttributes(
    //     (attributes) => attributes["file"] != null,
    //   );
    // });

    return InkWell(
      onTap: () async {
        await editorState.insertText(selection.startIndex, "{{",
            path: selection.start.path);
        // await editorState.insertText(selection.endIndex, "}}");
        await editorState.insertText(selection.endIndex + 2, "}}",
            path: selection.end.path);
      },
      child: Tooltip(
        message: "mark as template",
        preferBelow: false,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Bootstrap.marker_tip,
            color: Colors.white,
            size: 15,
          ),
        ),
      ),
    );
  },
);
