import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import 'sql_menu.dart';

const _menuWidth = 300;
const _hasTextHeight = 244;
const _noTextHeight = 150;

final sqlItem = ToolbarItem(
  id: 'editor.sql',
  group: 4,
  isActive: onlyShowInSingleSelectionAndTextType,
  builder: (context, editorState, highlightColor, iconColor) {
    final selection = editorState.selection!;
    final nodes = editorState.getNodesInSelection(selection);
    final isHref = nodes.allSatisfyInSelection(selection, (delta) {
      return delta.everyAttributes(
        (attributes) => attributes[AppFlowyRichTextKeys.href] != null,
      );
    });

    // return SVGIconItemWidget(
    //   iconName: 'toolbar/link',
    //   isHighlight: isHref,
    //   highlightColor: highlightColor,
    //   iconColor: iconColor,
    //   tooltip: AppFlowyEditorL10n.current.link,
    //   onPressed: () {
    //     showLinkMenu(context, editorState, selection, isHref);
    //   },
    // );
    return InkWell(
      onTap: () {
        showSqlMenu(context, editorState, selection, isHref);
      },
      child: Icon(
        Bootstrap.database,
        color: isHref ? Colors.blue : Colors.white,
      ),
    );
  },
);

/// copied from `link_toolbar_item.dart`
void showSqlMenu(
  BuildContext context,
  EditorState editorState,
  Selection selection,
  bool isHref,
) {
  String? linkText;
  if (isHref) {
    linkText = editorState.getDeltaAttributeValueInSelection(
      "sql",
      selection,
    );
  }

  final (left, top, right, bottom) = _getPosition(editorState, linkText);

  // get node, index and length for formatting text when the link is removed
  final node = editorState.getNodeAtPath(selection.end.path);
  if (node == null) {
    return;
  }
  final index = selection.normalized.startIndex;
  final length = selection.length;

  OverlayEntry? overlay;

  void dismissOverlay() {
    keepEditorFocusNotifier.decrease();
    overlay?.remove();
    overlay = null;
  }

  keepEditorFocusNotifier.increase();
  overlay = FullScreenOverlayEntry(
    top: top,
    bottom: bottom,
    left: left,
    right: right,
    dismissCallback: () => keepEditorFocusNotifier.decrease(),
    builder: (context) {
      return SqlMenu(
        linkText: linkText,
        editorState: editorState,
        onSubmitted: (text) async {
          await editorState.formatDelta(selection, {
            "sql": text,
          });
          dismissOverlay();
        },
        onRemoveSql: () {
          final transaction = editorState.transaction
            ..formatText(
              node,
              index,
              length,
              {BuiltInAttributeKey.href: null},
            );
          editorState.apply(transaction);
          dismissOverlay();
        },
        onDismiss: dismissOverlay,
      );
    },
  ).build();

  Overlay.of(context, rootOverlay: true).insert(overlay!);
}

// get a proper position for link menu
(double? left, double? top, double? right, double? bottom) _getPosition(
  EditorState editorState,
  String? linkText,
) {
  final rect = editorState.selectionRects().first;

  double? left, right, top, bottom;
  final offset = rect.center;
  final editorOffset = editorState.renderBox!.localToGlobal(Offset.zero);
  final editorWidth = editorState.renderBox!.size.width;
  (left, right) = _getStartEnd(
    editorWidth,
    offset.dx,
    editorOffset.dx,
    _menuWidth,
    rect.left,
    rect.right,
    true,
  );

  final editorHeight = editorState.renderBox!.size.height;
  (top, bottom) = _getStartEnd(
    editorHeight,
    offset.dy,
    editorOffset.dy,
    linkText != null ? _hasTextHeight : _noTextHeight,
    rect.top,
    rect.bottom,
    false,
  );

  return (left, top, right, bottom);
}

// This method calculates the start and end position for a specific
// direction (either horizontal or vertical) in the layout.
(double? start, double? end) _getStartEnd(
  double editorLength,
  double offsetD,
  double editorOffsetD,
  int menuLength,
  double rectStart,
  double rectEnd,
  bool isHorizontal,
) {
  final threshold = editorOffsetD + editorLength - _menuWidth;
  double? start, end;
  if (offsetD > threshold) {
    end = editorOffsetD + editorLength - rectStart - 5;
  } else if (isHorizontal) {
    start = rectStart;
  } else {
    start = rectEnd + 5;
  }

  return (start, end);
}
