import 'dart:io';

import 'package:all_in_one/app/linux.dart';
import 'package:all_in_one/app/windows.dart';
import 'package:all_in_one/common/dev_utils.dart';
import 'package:all_in_one/common/logger.dart';
import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/llm/ai_client.dart';
import 'package:all_in_one/src/rust/api/llm_api.dart' as llm;
import 'package:all_in_one/src/rust/api/software_monitor_api.dart' as smapi;
import 'package:all_in_one/src/rust/api/sub_window_api.dart' as sw;
import 'package:all_in_one/src/rust/api/system_monitor_api.dart' as sm;
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

  AiClient aiClient = AiClient();
  aiClient.initOpenAi(DevUtils.env);

  if (Platform.isWindows) {
    llm.initLlm(p: DevUtils.env);
    llm.initPromptFromPath(s: DevUtils.prompt);
    logger.info("CHAT_CHAT_BASE :${llm.getLlmConfig()?.chatBase}");
  }

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
    smapi.initMonitor(items: res);
  } else {
    smapi.initMonitor(items: []);
  }

  sm.startSystemMonitor();

  sw.createEventLoop();

  if (Platform.isWindows) {
    runWindowsAPP();
  }

  if (Platform.isLinux) {
    runLinuxAPP();
  }
}
