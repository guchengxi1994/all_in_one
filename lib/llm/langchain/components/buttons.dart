import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Buttons extends ConsumerWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FittedBox(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppStyle.appColor,
            border: Border.all(color: AppStyle.appColor),
            boxShadow: const [
              BoxShadow(
                color: AppStyle.appColor,
                offset: Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ]),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(toolProvider.notifier).changeState(null);
                ref.read(toolProvider.notifier).jumpTo(0);
              },
              child: _wrapper(const Text(
                "返回",
                style: TextStyle(color: Colors.white),
              )),
            ),
            const VerticalDivider(),
            GestureDetector(
              onTap: () {},
              child: _wrapper(const Text(
                "Chains",
                style: TextStyle(color: Colors.white),
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _wrapper(Widget child) {
    return SizedBox(
      width: 60,
      child: Center(
        child: child,
      ),
    );
  }
}
