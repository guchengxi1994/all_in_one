import 'package:all_in_one/software_monitor/components/software_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/software_calalog_list.dart';
import 'notifier/monitor_item_notifier.dart';

class SoftwareMonitorScreen extends ConsumerStatefulWidget {
  const SoftwareMonitorScreen({super.key});

  @override
  ConsumerState<SoftwareMonitorScreen> createState() =>
      _SoftwareMonitorScreenState();
}

class _SoftwareMonitorScreenState extends ConsumerState<SoftwareMonitorScreen> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(monitorItemProvider);

    return Scaffold(
      body: Row(
        children: [
          const SoftwareCatalogList(),
          Expanded(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: notifier.when(
                    data: (data) => SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: data.softwares
                              .map((e) => SoftwareItem(item: e))
                              .toList(),
                        ),
                      ),
                    ),
                    error: (Object error, StackTrace stackTrace) {
                      return Center(
                        child: Text(stackTrace.toString()),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )))
        ],
      ),
    );
  }
}
