import 'package:isar/isar.dart';

part 'recently_used.g.dart';

@collection
class RecentlyUsed {
  Id id = Isar.autoIncrement;
  late String toolName;
  late String router;
  int createAt = DateTime.now().millisecondsSinceEpoch;
}
