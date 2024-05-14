import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

final fileChatItem = ToolbarItem(
  id: 'editor.file',
  group: 4,
  isActive: onlyShowInSingleSelectionAndTextType,
  builder: (context, editorState, highlightColor, iconColor) {
    final selection = editorState.selection!;
    final nodes = editorState.getNodesInSelection(selection);
    final isFile = nodes.allSatisfyInSelection(selection, (delta) {
      return delta.everyAttributes(
        (attributes) => attributes["file"] != null,
      );
    });

    return InkWell(
      onTap: () async {
        /// TODO
        /// select file
        await editorState.formatDelta(selection, {
          "file": "c://file.f",
        });
      },
      child: Tooltip(
        message: "File",
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Bootstrap.file_binary,
            color: isFile ? Colors.blue : Colors.white,
            size: 15,
          ),
        ),
      ),
    );
  },
);
