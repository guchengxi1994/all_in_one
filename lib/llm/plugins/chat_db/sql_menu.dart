import 'package:all_in_one/llm/plugins/chat_db/db_notifier.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:appflowy_editor/src/editor/toolbar/desktop/items/utils/overlay_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_db_dialog.dart';

/// copied from `link_menu.dart`
class SqlMenu extends ConsumerStatefulWidget {
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
  ConsumerState<SqlMenu> createState() => _SqlMenuState();
}

class _SqlMenuState extends ConsumerState<SqlMenu> {
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
    final state = ref.watch(dbNotifierProvider);
    return Container(
      width: 300,
      decoration: buildOverlayDecoration(context),
      // padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: expanded ? 50 + state.info.length * 30 : 50,
            child: ExpansionTile(
              // trailing: const SizedBox(),
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(child: Text("Select your db")),
                  // const Icon(Bootstrap.database_check),
                  const SizedBox(
                    width: 50,
                  ),
                  InkWell(
                    onTap: () async {
                      widget.onDismiss();
                      showGeneralDialog(
                          barrierDismissible: true,
                          barrierLabel: "add-db",
                          context: context,
                          pageBuilder: (c, _, __) {
                            return const Center(
                              child: AddDbDialog(),
                            );
                          });
                    },
                    child: const Icon(Icons.add),
                  )
                ],
              ),
              children: state.info
                  .map((e) => Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 30,
                          child: Text(e.name),
                        ),
                      ))
                  .toList(),
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
