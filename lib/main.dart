import 'dart:io';

import 'package:all_in_one/app/windows.dart';
import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/src/rust/api/software_watcher_api.dart' as swapi;
import 'package:all_in_one/src/rust/frb_generated.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:timezone/data/latest.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await RustLib.init();
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  initializeDateFormatting();
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });

  IsarDatabase database = IsarDatabase();
  await database.initialDatabase();

  final watchings =
      await database.isar!.softwares.filter().isWatchingEqualTo(true).findAll();

  if (watchings.isNotEmpty) {
    List<(int, String)> res = [];
    for (final i in watchings) {
      if (i.associatedSoftwareName != null) {
        res.add((i.id, i.associatedSoftwareName!));
      }
    }
    swapi.initWatch(items: res);
  }

  if (Platform.isWindows) {
    runWindowsAPP();
  }
}
