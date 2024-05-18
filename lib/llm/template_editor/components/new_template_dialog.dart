import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';

class NewTemplateDialog extends StatefulWidget {
  const NewTemplateDialog({super.key});

  @override
  State<NewTemplateDialog> createState() => _NewTemplateDialogState();
}

class _NewTemplateDialogState extends State<NewTemplateDialog> {
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(4),
        elevation: 10,
        child: Container(
            width: 400,
            height: 160,
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('New Template'),
              const SizedBox(height: 16),
              SizedBox(
                height: 35,
                child: TextField(
                  controller: controller,
                  decoration: AppStyle.inputDecoration,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (controller.text == "") {
                          return;
                        }
                        Navigator.of(context).pop(controller.text);
                      },
                      child: const Text("确定"))
                ],
              )
            ])));
  }
}
