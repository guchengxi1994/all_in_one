import 'package:appflowy_editor/appflowy_editor.dart';

RegExp exp = RegExp(r'\{\{(.*?)\}\}');

extension EditorStateExtension on EditorState {
  String toStr() {
    final nodes = document.root.children;
    final buffer = StringBuffer();
    for (final node in nodes) {
      final delta = node.delta;
      if (delta != null) {
        String s = delta.toPlainText().replaceAll("👋 欢迎使用模板编辑器", "");
        // .replaceAll(exp, "");
        if (exp.hasMatch(s)) {
          s = s.replaceAll(exp, "");
          s = "<rewrite>$s</rewrite>";
        }

        buffer.writeln(s);
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
