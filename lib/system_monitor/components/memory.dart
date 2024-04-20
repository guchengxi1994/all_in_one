import 'package:all_in_one/styles/app_style.dart';
import 'package:all_in_one/system_monitor/notifiers/memory_notifier.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class Memory extends ConsumerWidget {
  const Memory({super.key});
  // final MemoryInfo? info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(memoryProvider);
    // print(info?.used);
    // print(info?.total);
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
            child: Text(
              "memory",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Expanded(
              child: info.memoryInfo == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppStyle.appCheckColor,
                      ),
                    )
                  : SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: AnimatedRadialGauge(
                          duration: const Duration(milliseconds: 300),
                          axis: const GaugeAxis(
                              min: 0,
                              max: 100,

                              /// Render the gauge as a 180-degree arc.
                              degrees: 180,

                              /// Set the background color and axis thickness.
                              style: GaugeAxisStyle(
                                thickness: 20,
                                background: Color(0xFFDFE2EC),
                                segmentSpacing: 4,
                              ),

                              /// Define the pointer that will indicate the progress (optional).
                              pointer: GaugePointer.triangle(
                                  borderRadius: 4,
                                  width: 23,
                                  height: 23,
                                  color: AppStyle.appColor,
                                  position: GaugePointerPosition(
                                      offset: Offset(5, 5))),

                              /// Define the progress bar (optional).
                              // progressBar: GaugeProgressBar.rounded(
                              //   color: Color(0xFFB4C2F8),
                              // ),

                              /// Define axis segments (optional).
                              segments: [
                                GaugeSegment(
                                  from: 0,
                                  to: 33.3,
                                  color: AppStyle.appCheckColor,
                                  cornerRadius: Radius.circular(10),
                                ),
                                GaugeSegment(
                                  from: 33.3,
                                  to: 66.6,
                                  color: AppStyle.orange,
                                  cornerRadius: Radius.circular(10),
                                ),
                                GaugeSegment(
                                  from: 66.6,
                                  to: 100,
                                  color: AppStyle.red,
                                  cornerRadius: Radius.circular(10),
                                ),
                              ]),
                          value: (100 *
                                  (info.memoryInfo!.used /
                                      info.memoryInfo!.total))
                              .ceilToDouble(),
                          builder: (context, child, value) {
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    "${(100 * (info.memoryInfo!.used / info.memoryInfo!.total)).ceilToDouble()} %",
                                    style: const TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                  Text(
                                      "${filesize(info.memoryInfo!.used)}/ ${filesize(info.memoryInfo!.total)}",
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white))
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ))
        ],
      ),
    );
  }
}
