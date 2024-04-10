import 'dart:async';
import 'dart:isolate';

import 'package:all_in_one/isar/schedule.dart';
import 'package:all_in_one/isar/software.dart';
import 'package:cron/cron.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class Message {
  final SendPort sendPort;
  final RootIsolateToken token;

  Message({required this.sendPort, required this.token});
}

class CronListener {
  CronListener._();

  static StreamController<List<ScheduleItem>> controller = StreamController();

  static start() {
    ReceivePort receivePort = ReceivePort();
    final token = RootIsolateToken.instance;

    receivePort.listen((message) {
      // print("message   $message");
      controller.sink.add(message);
    });
    Isolate.spawn((message) {
      _watchAndSendMessage(message);
    }, Message(sendPort: receivePort.sendPort, token: token!));
  }

  static Future _watchAndSendMessage(Message message) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(message.token);
    final dir = await getApplicationSupportDirectory();
    final cron = Cron();

    late List<CollectionSchema<Object>> schemas = [
      SoftwareSchema,
      SoftwareRunningSchema,
      SoftwareCatalogSchema,
      ForeGroundSchema,
      ScheduleItemSchema
    ];

    final isar = await Isar.open(
      schemas,
      directory: dir.path,
      name: 'AllInOne',
    );

    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      final now = DateTime.now();
      final last = DateTime(now.year, now.month, now.day, now.hour, now.minute)
          .millisecondsSinceEpoch;
      final items = await isar.scheduleItems
          .filter()
          .fromInMillBetween(last - 1000, last + 1000 * 60)
          .findAll();
      message.sendPort.send(items);
    });
  }
}
