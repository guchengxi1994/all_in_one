import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class Cpu extends StatelessWidget {
  const Cpu({super.key, required this.info});
  final CpuInfo? info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
            child: Text(
              "cpu",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Expanded(
              child: info == null
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
                          value: info!.current,
                          builder: (context, child, value) {
                            return Center(
                              child: Text(
                                "${(info!.current).ceil()} %",
                                style: const TextStyle(
                                    fontSize: 25, color: Colors.white),
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
