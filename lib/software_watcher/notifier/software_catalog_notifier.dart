import 'dart:async';

import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/software_watcher/notifier/watcher_item_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'software_catalog_state.dart';

class SoftwareCatalogNotifier
    extends AutoDisposeAsyncNotifier<SoftwareCatalogState> {
  final IsarDatabase database = IsarDatabase();
  @override
  FutureOr<SoftwareCatalogState> build() async {
    final catalogs = await database.isar!.softwareCatalogs.where().findAll();
    return SoftwareCatalogState(catalogs: catalogs);
  }

  addNewCatalog(String name) async {
    SoftwareCatalog catalog = SoftwareCatalog()..name = name;
    await database.isar!.writeTxn(() async {
      await database.isar!.softwareCatalogs.put(catalog);
    });
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final catalogs = await database.isar!.softwareCatalogs.where().findAll();
      return SoftwareCatalogState(catalogs: catalogs);
    });
  }

  markItemCatalog(int itemId, SoftwareCatalog catalog) async {
    final item =
        await database.isar!.softwares.where().idEqualTo(itemId).findFirst();
    if (item != null) {
      item.catalog.value = catalog;
      await database.isar!.writeTxn(() async {
        await item.catalog.save();
      });
    }
  }

  deleteCatalog(int id) async {
    final items = await database.isar!.softwares
        .filter()
        .catalog((q) => q.idEqualTo(id))
        .findAll();
    final catalog = await database.isar!.softwareCatalogs.where().findFirst();
    await database.isar!.writeTxn(() async {
      for (final i in items) {
        i.catalog.value = catalog;
        await i.catalog.save();
      }
      await database.isar!.softwareCatalogs.delete(id);
    });
    state = await AsyncValue.guard(() async {
      final catalogs = await database.isar!.softwareCatalogs.where().findAll();
      ref.read(watcherItemProvider.notifier).filter(1);
      return SoftwareCatalogState(catalogs: catalogs, current: 1);
    });
  }

  changeCurrent(int id) async {
    if (state.value!.current == id) {
      return;
    }
    state = await AsyncValue.guard(() async {
      return SoftwareCatalogState(catalogs: state.value!.catalogs, current: id);
    });

    ref.read(watcherItemProvider.notifier).filter(state.value!.current);
  }
}

final softwareCatalogProvider = AutoDisposeAsyncNotifierProvider<
    SoftwareCatalogNotifier, SoftwareCatalogState>(
  () => SoftwareCatalogNotifier(),
);
