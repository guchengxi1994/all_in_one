import 'dart:async';

import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/software_watcher/notifier/watcher_item_state.dart';
import 'package:all_in_one/src/rust/api/software_watcher_api.dart' as swapi;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class WatcherItemNotifier extends AutoDisposeAsyncNotifier<WatcherItemState> {
  final IsarDatabase database = IsarDatabase();

  @override
  FutureOr<WatcherItemState> build() async {
    final items = await database.isar!.softwares.where().findAll();
    if (items.isNotEmpty) {
      return WatcherItemState(softwares: items);
    }
    final firstTimeSoftwares = await swapi.getWindowsInstalledSoftwares();
    List<Software> softwares = [];
    for (final i in firstTimeSoftwares) {
      Software software = Software()..name = i.name;
      software.icon = i.icon;
      software.iconPath = i.iconPath;
      softwares.add(software);
    }

    await database.isar!.writeTxn(() async {
      await database.isar!.softwares.putAll(softwares);
    });

    return WatcherItemState(softwares: softwares);
  }
}

final watcherItemProvider =
    AutoDisposeAsyncNotifierProvider<WatcherItemNotifier, WatcherItemState>(
        () => WatcherItemNotifier());
