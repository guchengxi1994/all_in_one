import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/isar/recently_used.dart';
import 'package:all_in_one/isar/schedule.dart';
import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/common/logger.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatabase {
  // ignore: avoid_init_to_null
  late Isar? isar = null;

  static final _instance = IsarDatabase._init();

  factory IsarDatabase() => _instance;

  IsarDatabase._init();

  late List<CollectionSchema<Object>> schemas = [
    SoftwareSchema,
    SoftwareRunningSchema,
    SoftwareCatalogSchema,
    ForeGroundSchema,
    ScheduleItemSchema,
    RecentlyUsedSchema,
    LLMHistorySchema,
    LLMHistoryMessageSchema
  ];

  Future initialDatabase() async {
    if (isar != null && isar!.isOpen) {
      return;
    }
    final dir = await getApplicationSupportDirectory();
    logger.info("database save to ${dir.path}");
    isar = await Isar.open(
      schemas,
      name: "AllInOne",
      directory: dir.path,
    );

    final count = isar!.softwareCatalogs.where().countSync();
    if (count == 0) {
      isar!.writeTxnSync(() {
        isar!.softwareCatalogs.putSync(SoftwareCatalog()
          ..name = "全部"
          ..deletable = false);
      });
    }
  }
}
