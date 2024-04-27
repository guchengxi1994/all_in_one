import 'dart:async';
import 'dart:collection';

import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/recently_used.dart';
import 'package:all_in_one/tool_entry/routers/routers.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

const limit = 10;

class EntryNotifier extends AutoDisposeAsyncNotifier {
  final IsarDatabase isarDatabase = IsarDatabase();
  @override
  FutureOr build() {}

  Future newRecord(String? name, String router) async {
    if (name == null) {
      return;
    }

    await isarDatabase.isar!.writeTxn(() async {
      RecentlyUsed recentlyUsed = RecentlyUsed()
        ..toolName = name
        ..router = router;
      await isarDatabase.isar!.recentlyUseds.put(recentlyUsed);
    });
  }

  Future<List<(String, String)>> getOrdered() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final records = await isarDatabase.isar!.recentlyUseds
        .filter()
        .createAtGreaterThan(sevenDaysAgo.millisecondsSinceEpoch)
        .findAll();
    Map<String, int> m = {};

    for (var element in records) {
      m[element.router] = (m[element.router] ?? 0) + 1;
    }

    LinkedHashMap<String, int> sortedMap = LinkedHashMap.from(m);
    final s = sortedMap.entries.sorted((a, b) => b.value.compareTo(a.value));
    // print(sortedMap);
    List<(String, String)> results = [];
    int count = 0;
    for (final i in s) {
      results.add((i.key, Routers.toolRouters[i.key]!));
      count += 1;
      if (count >= limit) {
        break;
      }
    }
    return results;
  }
}

final entryProvider = AutoDisposeAsyncNotifierProvider<EntryNotifier, void>(
    () => EntryNotifier());
