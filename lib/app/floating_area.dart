import 'dart:convert';

import 'package:all_in_one/app/float_notifier.dart';
import 'package:all_in_one/common/toast_utils.dart';
import 'package:all_in_one/llm/ai_client.dart';
import 'package:all_in_one/schedule/notifier/schedule_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingArea extends ConsumerStatefulWidget {
  const FloatingArea({super.key});

  @override
  ConsumerState<FloatingArea> createState() => _FloatingAreaState();
}

class _FloatingAreaState extends ConsumerState<FloatingArea> {
  final TextEditingController controller = TextEditingController();
  final AiClient client = AiClient();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
          submit();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(floatProvider);
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 10,
      child: GestureDetector(
        onDoubleTap: () {
          ref.read(floatProvider.notifier).changeState();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.blue),
          child: state
              ? Column(
                  children: [
                    Expanded(
                        child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      child: Focus(
                          autofocus: true,
                          child: TextField(
                            focusNode: _inputFocusNode,
                            controller: controller,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 159, 159, 159),
                                  fontSize: 12),
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 15),
                              border: InputBorder.none,
                              // focusedErrorBorder:
                              //     OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            ),
                          )),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          ElevatedButton(
                              onPressed: () => submit(),
                              child: Transform.rotate(
                                angle: 3.14 / 4,
                                child: const Icon(Icons.navigation),
                              ))
                        ],
                      ),
                    )
                  ],
                )
              : Image.asset("assets/icons/robot.png"),
        ),
      ),
    );
  }

  submit() async {
    if (controller.text == "") {
      return;
    }

    client.textToSchedule(controller.text).then((v) {
      // print(v.outputAsString);
      try {
        Map<String, dynamic> map = jsonDecode(v.outputAsString);
        ref
            .read(scheduleProvider.notifier)
            .addEvent(
                from: DateTime.fromMillisecondsSinceEpoch(map['fromInMill']),
                to: DateTime.fromMillisecondsSinceEpoch(map['toInMill']),
                eventName: map['eventName'],
                refreshUI: false)
            .then((_) {
          controller.text = "";
          ToastUtils.sucess(context, title: "Schedule created");
          ref.read(floatProvider.notifier).changeState();
        });
      } catch (_) {
        ToastUtils.error(context, title: "LLM response error");
      }
    });
  }
}
