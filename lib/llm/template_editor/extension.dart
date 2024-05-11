import 'package:appflowy_editor/appflowy_editor.dart';

extension EditorStateExtension on EditorState {
  String toStr() {
    final nodes = document.root.children;
    final buffer = StringBuffer();
    for (final node in nodes) {
      final delta = node.delta;
      if (delta != null) {
        buffer.writeln(delta.toPlainText());
      } else {
        if (node.type == DividerBlockKeys.type) {
          buffer.writeln('---');
        }
      }
    }
    final plainTexts = buffer.toString();
    return plainTexts;
  }
}
