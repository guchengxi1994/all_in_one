import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

part 'article.g.dart';

@collection
class Article {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  late String title;
  late String content;
  @Index(unique: true)
  late String hash = calculateMD5(content);
}

String calculateMD5(String input) {
  Uint8List bytes = utf8.encode(input);

  Digest digest = md5.convert(bytes);
  return digest.toString();
}
