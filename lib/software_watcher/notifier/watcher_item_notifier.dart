import 'dart:async';

import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/software_watcher/notifier/watcher_item_state.dart';
import 'package:all_in_one/src/rust/api/software_watcher_api.dart' as swapi;
import 'package:all_in_one/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class WatcherItemNotifier extends AutoDisposeAsyncNotifier<WatcherItemState> {
  final IsarDatabase database = IsarDatabase();

  @override
  FutureOr<WatcherItemState> build() async {
    final items = await database.isar!.softwares.where().findAll();
    final defaultCatalog =
        await database.isar!.softwareCatalogs.where().findFirst();
    if (items.isNotEmpty) {
      return WatcherItemState(softwares: items);
    }
    final firstTimeSoftwares = await swapi.getWindowsInstalledSoftwares();
    List<Software> softwares = [];
    for (final i in firstTimeSoftwares) {
      Software software = Software()..name = i.name;
      software.icon = i.icon;
      software.iconPath = i.iconPath;
      software.catalog.value = defaultCatalog;
      softwares.add(software);
    }

    await database.isar!.writeTxn(() async {
      await database.isar!.softwares.putAll(softwares);
      for (final i in softwares) {
        await i.catalog.save();
      }
    });

    return WatcherItemState(softwares: softwares);
  }

  filter(int catalogId) async {
    logger.info("catalogId id $catalogId");
    final List<Software> items;
    if (catalogId == 1) {
      items = await database.isar!.softwares.where().findAll();
    } else {
      items = await database.isar!.softwares
          .filter()
          .catalog((q) => q.idEqualTo(catalogId))
          .findAll();
    }

    state = await AsyncValue.guard(
      () async {
        return WatcherItemState(softwares: items);
      },
    );
  }

  refreshCurrent(int catalogId) async {
    final List<Software> items;
    if (catalogId == 1) {
      items = await database.isar!.softwares.where().findAll();
    } else {
      items = await database.isar!.softwares
          .filter()
          .catalog((q) => q.idEqualTo(catalogId))
          .findAll();
    }

    state = await AsyncValue.guard(
      () async {
        return WatcherItemState(softwares: items);
      },
    );
  }

  saveItem(Software item) async {
    await database.isar!.writeTxn(() async {
      await database.isar!.softwares.put(item);
    });
  }

  updateRunning(List<int> ids, {String? foreground}) async {
    final items = await database.isar!.softwares.getAll(ids);
    if (items.isEmpty) {
      return;
    }
    await database.isar!.writeTxn(() async {
      // await database.isar!.softwares.put(item);
      final SoftwareRunning running = SoftwareRunning();
      await database.isar!.softwareRunnings.put(running);
      for (final i in items) {
        if (i != null) {
          i.runnings.add(running);
          await i.runnings.save();
        }
      }

      if (foreground != null && foreground != "") {
        final ForeGround foreGround = ForeGround()..name = foreground;
        await database.isar!.foreGrounds.put(foreGround);
      }
    });
  }
}

final watcherItemProvider =
    AutoDisposeAsyncNotifierProvider<WatcherItemNotifier, WatcherItemState>(
        () => WatcherItemNotifier());
