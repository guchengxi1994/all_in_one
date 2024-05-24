import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef OnSave = void Function(String);

class AddTagButton extends ConsumerStatefulWidget {
  const AddTagButton({super.key, required this.onSave});
  final OnSave onSave;

  @override
  ConsumerState<AddTagButton> createState() => _AddTagButtonState();
}

const double size = 30;

class _AddTagButtonState extends ConsumerState<AddTagButton> {
  bool isActivate = false;
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: FittedBox(
        child: !isActivate
            ? InkWell(
                onTap: () {
                  setState(() {
                    isActivate = !isActivate;
                  });
                },
                child: const Icon(
                  Icons.add,
                  size: size,
                ),
              )
            : SizedBox(
                width: 400,
                height: size,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: controller,
                      style: const TextStyle(fontSize: 12),
                      keyboardType: TextInputType.text,
                      decoration: AppStyle.inputDecoration,
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.check,
                        size: size,
                      ),
                      onTap: () {
                        setState(() {
                          widget.onSave(controller.text);
                          isActivate = !isActivate;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.refresh,
                        size: size,
                      ),
                      onTap: () {
                        controller.text = "";
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
