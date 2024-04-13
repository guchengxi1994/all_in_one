import 'package:all_in_one/entry/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import 'components/entry_button.dart';

class EntryScreen extends ConsumerWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            runSpacing: 15,
            spacing: 15,
            children: [
              EntryButton(
                onTap: () {
                  ref
                      .read(routersProvider.notifier)
                      .changeRouter(Routers.softwareWatcherScreen);
                },
                name: 'watcher',
                icon: const Icon(
                  Bootstrap.app,
                  size: 30,
                ),
              ),
              EntryButton(
                onTap: () {
                  ref
                      .read(routersProvider.notifier)
                      .changeRouter(Routers.scheduleScreen);
                },
                name: 'schedule',
                icon: const Icon(
                  Bootstrap.card_checklist,
                  size: 30,
                ),
              ),
              EntryButton(
                onTap: () {
                  ref
                      .read(routersProvider.notifier)
                      .changeRouter(Routers.timeConverterScreen);
                },
                name: 'converter',
                icon: const Icon(
                  Bootstrap.clock,
                  size: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
