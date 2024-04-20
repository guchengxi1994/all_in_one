import 'package:all_in_one/system_monitor/notifiers/cpu_notifier.dart';
import 'package:collection/collection.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CpuHistory extends ConsumerWidget {
  const CpuHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(cpuProvider).history;
    List<NumericData> numericDataList = history
        .mapIndexed((i, e) => NumericData(domain: i, measure: e))
        .toList();

    final numericGroupList = [
      NumericGroup(
        color: Colors.white,
        id: '1',
        data: numericDataList,
      ),
    ];

    return DChartLineN(
      groupList: numericGroupList,
    );
  }
}
