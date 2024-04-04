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

  @Index(unique: true)
  late String name;
}
