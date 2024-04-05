import 'package:all_in_one/software_watcher/components/software_item.dart';
import 'package:all_in_one/src/rust/api/software_watcher_api.dart' as swapi;
import 'package:all_in_one/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/software_calalog_list.dart';
import 'notifier/watcher_item_notifier.dart';

class SoftwareWatcherScreen extends ConsumerStatefulWidget {
  const SoftwareWatcherScreen({super.key});

  @override
  ConsumerState<SoftwareWatcherScreen> createState() =>
      _SoftwareWatcherScreenState();
}

class _SoftwareWatcherScreenState extends ConsumerState<SoftwareWatcherScreen> {
  final stream = swapi.softwareWatchingMessageStream();

  @override
  void initState() {
    super.initState();
    stream.listen((event) {
      // print(event);
      logger.info(event);
      ref
          .read(watcherItemProvider.notifier)
          .updateRunning(event.map((element) => element.toInt()).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(watcherItemProvider);

    return Row(
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
    );
  }
}
