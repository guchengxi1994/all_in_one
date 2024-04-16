// ignore_for_file: avoid_init_to_null

import 'package:all_in_one/src/rust/api/system_monitor_api.dart' as sm;
import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:all_in_one/system_monitor/components/cpu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/disks.dart';

class SystemMonitorScreen extends ConsumerStatefulWidget {
  const SystemMonitorScreen({super.key});

  @override
  ConsumerState<SystemMonitorScreen> createState() =>
      _SystemMonitorScreenState();
}

class _SystemMonitorScreenState extends ConsumerState<SystemMonitorScreen> {
  final stream = sm.systemMonitorMessageStream();

  late List<MountedInfo> info = [];
  late CpuInfo? cpuInfo = null;

  @override
  void initState() {
    super.initState();
    stream.listen((event) {
      // print("event.disks?.length  ${event.disks?.length}");

      setState(() {
        info = event.disks ?? [];
        cpuInfo = event.cpu;

        // print(cpuInfo!.intr + cpuInfo!.system + cpuInfo!.user);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.appColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: LayoutGrid(
          areas: """
area2 area3 area4
area5 area6 area4
area1 area1 area1
""",
          columnSizes: [250.fr, 250.fr, 250.fr],
          rowSizes: [
            120.fr,
            120.fr,
            120.fr,
          ],
          columnGap: 12,
          rowGap: 12,
          children: [
            _wrapper(Disks(
              info: info,
            )).inGridArea("area1"),
            _wrapper(Cpu(info: cpuInfo)).inGridArea("area2"),
            _wrapper(null).inGridArea("area3"),
            _wrapper(null).inGridArea("area4"),
            _wrapper(null).inGridArea("area5"),
            _wrapper(null).inGridArea("area6")
          ],
        ),
      ),
    );
  }

  Widget _wrapper(Widget? child) {
    return Container(
      decoration: BoxDecoration(
          color: AppStyle.appColorDark, borderRadius: BorderRadius.circular(4)),
      child: child,
    );
  }
}
