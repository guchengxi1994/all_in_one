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
    // for (final i in nodes) {
    //   print(i.delta?.toJson());
    // }
    final first = nodes.firstOrNull;
    final last = nodes.lastOrNull;
    var isTemplate = false;
    if (first != null && last != null) {
      if (first.delta != null &&
          first.delta!.toJson()[0]['insert'].toString().startsWith("{{") &&
          last.delta != null &&
          last.delta!.toJson()[0]['insert'].toString().endsWith("}}")) {
        isTemplate = true;
      }
    }

    return InkWell(
      onTap: () async {
        // await editorState.deleteSelection(selection)

        if (!isTemplate) {
          await editorState.insertText(selection.startIndex, "{{",
              path: selection.start.path);
          // await editorState.insertText(selection.endIndex, "}}");
          await editorState.insertText(selection.endIndex + 2, "}}",
              path: selection.end.path);
        } else {
          // print(selection.start);
          // await editorState.document.updateText(selection.start.path, Delta.fromJson(list));
          Selection startSelection = Selection(
              start: Position(path: selection.start.path, offset: 0),
              end: Position(path: selection.start.path, offset: 2));

          Selection endSelection = Selection(
              start: Position(
                  path: startSelection.start.path,
                  offset: selection.endIndex - 4),
              end: Position(
                  path: startSelection.start.path,
                  offset: selection.endIndex - 2));

          // print(_selection.toJson());

          await editorState.deleteSelection(startSelection);
          await editorState.deleteSelection(endSelection);
        }
      },
      child: Tooltip(
        message: !isTemplate ? "mark as template" : "cancel template",
        preferBelow: false,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Bootstrap.marker_tip,
            color: isTemplate ? Colors.blue : Colors.white,
            size: 15,
          ),
        ),
      ),
    );
  },
);
