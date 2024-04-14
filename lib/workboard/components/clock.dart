import 'package:all_in_one/workboard/notifiers/workboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class Clock extends ConsumerWidget {
  const Clock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return const Placeholder();
    return SizedBox.expand(
      child: StreamBuilder(
          stream: ref.read(workboardProvider.notifier).timeStream(),
          builder: (c, s) {
            if (s.data == null) {
              return const CircularProgressIndicator();
            }
            var minute = "";
            if (s.data!.minute < 10) {
              minute = "0${s.data!.minute}";
            } else {
              minute = s.data!.minute.toString();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${s.data!.hour}:$minute",
                  style: const TextStyle(fontSize: 36, color: Colors.white),
                ),
                Text(
                  "${s.data!.month}月${s.data!.day}日 ${DateFormat('EEEE', "zh_CN").format(s.data!)}",
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ],
            );
          }),
    );
  }
}
