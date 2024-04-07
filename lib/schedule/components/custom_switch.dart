import 'package:all_in_one/schedule/notifiers/schedule_type_notifier.dart';
import 'package:all_in_one/schedule/notifiers/schedule_type_state.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSwitchButton extends ConsumerWidget {
  const CustomSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scheduleTypeProvider);
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: AppStyle.appColor, borderRadius: BorderRadius.circular(3)),
      child: FittedBox(
        child: Row(
          children: state.switches
              .map((e) => GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.only(left: 1, right: 1),
                      decoration: BoxDecoration(
                          color: e != state.current
                              ? Colors.white
                              : Colors.transparent),
                      child: Text(e.toStr()),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
