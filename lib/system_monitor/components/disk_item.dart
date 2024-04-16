import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

class DiskItem extends StatelessWidget {
  const DiskItem({super.key, required this.info});
  final MountedInfo info;

  @override
  Widget build(BuildContext context) {
    final r = 1 - info.available / info.total;
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/icons/disk.png",
              width: 60,
              fit: BoxFit.fitWidth,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${info.name}(${info.disk.replaceAll("\\", "")})",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 200,
                  height: 20,
                  child: LinearProgressIndicator(
                    color: r >= 0.9
                        ? AppStyle.red
                        : r >= 0.6
                            ? AppStyle.orange
                            : AppStyle.appCheckColor,
                    value: r,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${filesize(info.available)}可用,共${filesize(info.total)}",
                  style: const TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
