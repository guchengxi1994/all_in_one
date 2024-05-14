import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:appflowy_editor/src/editor/toolbar/desktop/items/utils/overlay_util.dart';
import 'package:icons_plus/icons_plus.dart';

/// copied from `link_menu.dart`
class SqlMenu extends StatefulWidget {
  const SqlMenu(
      {super.key,
      this.linkText,
      this.editorState,
      required this.onSubmitted,
      required this.onDismiss,
      required this.onRemoveSql});
  final String? linkText;
  final EditorState? editorState;
  final void Function(String text) onSubmitted;
  final VoidCallback onDismiss;
  final VoidCallback onRemoveSql;

  @override
  State<SqlMenu> createState() => _SqlMenuState();
}

class _SqlMenuState extends State<SqlMenu> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  bool expanded = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.linkText ?? '';
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: buildOverlayDecoration(context),
      // padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: expanded ? 200 : 50,
            child: ExpansionTile(
              trailing: const SizedBox(),
              onExpansionChanged: (b) {
                setState(() {
                  expanded = b;
                });
              },
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(0)),
              collapsedShape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(0)),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Select your db"),
                  Icon(Bootstrap.database_check)
                ],
              ),
              children: [
                const Text("String"),
                const Text("String"),
                const Text("String"),
                const Text("String"),
                const Text("String"),
                const Text("String")
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (key) {
          if (key is KeyDownEvent &&
              key.logicalKey == LogicalKeyboardKey.escape) {
            widget.onDismiss();
          }
        },
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: _focusNode,
          textAlign: TextAlign.left,
          controller: _textEditingController,
          onFieldSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: "sql string",
            contentPadding: const EdgeInsets.all(16.0),
            isDense: true,
            suffixIcon: IconButton(
              padding: const EdgeInsets.all(4.0),
              icon: const EditorSvg(
                name: 'clear',
                width: 24,
                height: 24,
              ),
              onPressed: _textEditingController.clear,
              splashRadius: 5,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
        ),
      ),
    );
  }
}
