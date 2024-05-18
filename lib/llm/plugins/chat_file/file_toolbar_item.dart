import 'package:all_in_one/llm/plugins/chat_file/group.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:file_selector/file_selector.dart';
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
      child: Tooltip(
        message: "File",
        preferBelow: false,
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
