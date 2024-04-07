import 'dart:typed_data';

import 'package:isar/isar.dart';

part 'software.g.dart';

@collection
class Software {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  bool isWatching = false;
  @Index(unique: true)
  late String name;
  String? iconPath;
  List<int>? icon;
  String? associatedSoftwareName;
  String? shortName;
  bool display = false;

  final runnings = IsarLinks<SoftwareRunning>();
  final catalog = IsarLink<SoftwareCatalog>();

  @override
  bool operator ==(Object other) {
    if (other is! Software) {
      return false;
    }
    return identical(this, other) || other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  Uint8List? convertIconToByteList() {
    return icon == null ? null : Uint8List.fromList(icon!);
  }

  List<int> last24Hours() {
    List<int> res = [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int last = today.millisecondsSinceEpoch;
    for (int i = 0; i <= 23; i++) {
      int unixEndOfHour = today
          .add(Duration(hours: i, minutes: 59, seconds: 59))
          .millisecondsSinceEpoch;
      final r = runnings
          .where((element) =>
              element.createAt > last && element.createAt <= unixEndOfHour)
          .length;
      last = unixEndOfHour;
      res.add(r);
    }
    return res;
  }

  int today() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int unixEpochStartOfDay = today.millisecondsSinceEpoch;
    int unixEndOfDay = today
        .add(const Duration(hours: 23, minutes: 59, seconds: 59))
        .millisecondsSinceEpoch;
    final r = runnings.where((element) =>
        element.createAt > unixEpochStartOfDay &&
        element.createAt <= unixEndOfDay);
    return r.length;
  }

  List<int> sevenDays() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime firstDay = today.subtract(const Duration(days: 6));
    int last = firstDay.millisecondsSinceEpoch;
    List<int> res = [];
    for (int i = 1; i <= 7; i++) {
      int unixEndOfDay = firstDay.add(Duration(days: i)).millisecondsSinceEpoch;

      /// 这里如果 写成
      /// ```
      ///   final r = runnings.where((element) {
      ///       return element.createAt > last && element.createAt <= unixEndOfDay;
      ///   })
      /// ```
      /// 然后通过 ```r.length```获取列表长度
      /// 会拿不到长度，应该是 IsarLinks底层
      /// 有异步
      final r = runnings.where((element) {
        return element.createAt > last && element.createAt <= unixEndOfDay;
      }).length;

      last = unixEndOfDay;
      res.add(r);
    }
    return res;
  }
}

@collection
class SoftwareRunning {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
}

@collection
class SoftwareCatalog {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  bool deletable = true;
  String? catalogIconName;

  @Index(unique: true)
  late String name;
}

/// only works on windows for now
@collection
class ForeGround {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  late String name;
}
