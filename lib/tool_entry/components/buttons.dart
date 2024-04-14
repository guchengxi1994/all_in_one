import 'package:all_in_one/routers/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import 'entry_button.dart';

watcherButton(WidgetRef ref) => EntryButton(
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
    );

scheduleButton(WidgetRef ref) => EntryButton(
      onTap: () {
        ref.read(routersProvider.notifier).changeRouter(Routers.scheduleScreen);
      },
      name: 'schedule',
      icon: const Icon(
        Bootstrap.card_checklist,
        size: 30,
      ),
    );
converterButton(WidgetRef ref) => EntryButton(
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
    );

Widget getByName(String s, WidgetRef ref) {
  switch (s) {
    case 'watcher':
      return watcherButton(ref);
    case 'schedule':
      return scheduleButton(ref);
    case 'converter':
      return converterButton(ref);
    default:
      return const SizedBox();
  }
}
