import 'package:all_in_one/styles/app_style.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnSubmit = void Function(String);

const XTypeGroup txtsTypeGroup = XTypeGroup(
  label: 'TXTs',
  extensions: <String>['txt'],
);

typedef OnFileSelected = void Function(XFile);

class InputField extends StatefulWidget {
  const InputField(
      {super.key,
      required this.onSubmit,
      this.showUploadFileButton = false,
      this.onFileSelected,
      this.onChain});
  final OnSubmit onSubmit;
  final bool showUploadFileButton;
  final OnFileSelected? onFileSelected;
  final OnFileSelected? onChain;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final _inputFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      if (event.physicalKey == PhysicalKeyboardKey.enter &&
          !HardwareKeyboard.instance.physicalKeysPressed.any(
            (el) => <PhysicalKeyboardKey>{
              PhysicalKeyboardKey.shiftLeft,
              PhysicalKeyboardKey.shiftRight,
            }.contains(el),
          )) {
        if (event is KeyDownEvent) {
          _handleSendPressed();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  late TextEditingController _textController;

  @override
  void dispose() {
    _textController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
  }

  _handleSendPressed() {
    if (_textController.text == "") {
      return;
    }

    widget.onSubmit(_textController.text);
    _textController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
                child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    focusNode: _inputFocusNode,
                    controller: _textController,
                    decoration: InputDecoration(
                        hintText: "请输入对话内容",
                        hintStyle: TextStyle(
                            fontSize: 14, color: AppStyle.black515A6E),
                        contentPadding: const EdgeInsets.only(left: 16),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppStyle.divider, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppStyle.blue247AF2, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (widget.showUploadFileButton)
                                IconButton(
                                    padding: const EdgeInsets.only(bottom: 1),
                                    onPressed: () async {
                                      final XFile? file = await openFile(
                                          acceptedTypeGroups: <XTypeGroup>[
                                            txtsTypeGroup
                                          ]);

                                      if (file != null &&
                                          widget.onChain != null) {
                                        widget.onChain!(file);
                                      }
                                    },
                                    icon: const Icon(Icons.link)),
                              if (widget.showUploadFileButton)
                                IconButton(
                                    padding: const EdgeInsets.only(bottom: 1),
                                    onPressed: () async {
                                      final XFile? file = await openFile(
                                          acceptedTypeGroups: <XTypeGroup>[
                                            txtsTypeGroup
                                          ]);

                                      if (file != null &&
                                          widget.onFileSelected != null) {
                                        widget.onFileSelected!(file);
                                      }
                                    },
                                    icon: const Icon(Icons.upload)),
                              IconButton(
                                  padding: const EdgeInsets.only(bottom: 1),
                                  onPressed: () {
                                    _handleSendPressed();
                                  },
                                  icon: const Icon(Icons.send))
                            ],
                          ),
                        ))))
          ],
        ),
      ),
    );
  }
}
