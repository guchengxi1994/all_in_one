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
        } else {
          if (s != "") {
            s = "<keep>$s</keep>";
          }
        }

        buffer.writeln(s);
      }
    }
    final plainTexts = buffer.toString();

    return plainTexts;
  }

  String toStr2() {
    final nodes = document.root.children;
    final buffer = StringBuffer();
    for (final node in nodes) {
      final delta = node.delta;
      if (delta != null) {
        String s = delta.toPlainText();

        buffer.writeln(s);
      }
    }
    final plainTexts = buffer.toString();

    return plainTexts;
  }
}
