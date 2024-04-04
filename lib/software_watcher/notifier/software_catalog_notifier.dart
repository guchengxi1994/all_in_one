import 'dart:async';

import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/software.dart';
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
}

final softwareCatalogProvider = AutoDisposeAsyncNotifierProvider<
    SoftwareCatalogNotifier, SoftwareCatalogState>(
  () => SoftwareCatalogNotifier(),
);
