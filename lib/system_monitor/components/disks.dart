import 'package:all_in_one/styles/app_style.dart';
import 'package:all_in_one/system_monitor/components/disk_item.dart';
import 'package:all_in_one/system_monitor/notifiers/disks_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Disks extends ConsumerWidget {
  const Disks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(disksProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
            child: Text(
              "disks",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Expanded(
            child: info.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: info.map((e) => DiskItem(info: e)).toList(),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppStyle.appCheckColor,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
