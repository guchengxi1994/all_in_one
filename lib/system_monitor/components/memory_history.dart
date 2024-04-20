import 'package:all_in_one/system_monitor/notifiers/memory_notifier.dart';
import 'package:collection/collection.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoryHistory extends ConsumerWidget {
  const MemoryHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(memoryProvider).history;

    List<NumericData> numericDataList = history
        .mapIndexed((i, e) => NumericData(domain: i, measure: e * 100))
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
