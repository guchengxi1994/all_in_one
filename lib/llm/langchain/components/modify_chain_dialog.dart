import 'package:all_in_one/llm/langchain/models/chains.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';

class ModifyChainDialog extends StatefulWidget {
  const ModifyChainDialog({super.key, required this.item});
  final FlowElement item;

  @override
  State<ModifyChainDialog> createState() => _ModifyChainDialogState();
}

class _ModifyChainDialogState extends State<ModifyChainDialog> {
  late final TextEditingController itemTextController = TextEditingController()
    ..text = widget.item.text;
  final itemTextFocusNode = FocusNode();
  final TextEditingController inputKeyController = TextEditingController();
  final inputKeyFocusNode = FocusNode();
  final TextEditingController outputKeyController = TextEditingController();
  final outputKeyFocusNode = FocusNode();
  final TextEditingController promptController = TextEditingController()
    ..text = "{{placeholder}}";
  final promptFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        height: 320,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                _wrapper(
                    "name",
                    SizedBox(
                      height: 30,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value == "") {
                            return "";
                          }
                          return null;
                        },
                        controller: itemTextController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                        decoration: AppStyle.inputDecoration,
                        autofocus: true,
                        onFieldSubmitted: (value) {
                          inputKeyFocusNode.requestFocus();
                        },
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                _wrapper(
                    "input",
                    SizedBox(
                        height: 30,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value == "") {
                              return "";
                            }
                            return null;
                          },
                          controller: inputKeyController,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          decoration: AppStyle.inputDecoration,
                          autofocus: false,
                          onFieldSubmitted: (value) {
                            outputKeyFocusNode.requestFocus();
                          },
                        ))),
                const SizedBox(
                  height: 20,
                ),
                _wrapper(
                    "output",
                    SizedBox(
                        height: 30,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value == "") {
                              return "";
                            }
                            return null;
                          },
                          controller: outputKeyController,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          decoration: AppStyle.inputDecoration,
                          autofocus: false,
                          onFieldSubmitted: (value) {
                            promptFocusNode.requestFocus();
                          },
                        ))),
                const SizedBox(
                  height: 20,
                ),
                _wrapper(
                    "prompt",
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == "") {
                          return "";
                        }
                        if (value.contains("{{placeholder}}")) {
                          return null;
                        }

                        return "";
                      },
                      maxLines: 3,
                      controller: promptController,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                      decoration: AppStyle.inputDecoration,
                      autofocus: false,
                      onFieldSubmitted: (value) {
                        _formKey.currentState!.validate();
                      },
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop((
                              itemTextController.text,
                              ChainItem(
                                  inputKey: inputKeyController.text,
                                  outputKey: outputKeyController.text,
                                  prompt: promptController.text)
                            ));
                          }
                        },
                        child: const Text("确定"))
                  ],
                )
              ],
            )),
      ),
    );
  }

  _wrapper(String title, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(title),
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ))
      ],
    );
  }
}
