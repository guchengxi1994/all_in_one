import 'package:isar/isar.dart';

part 'article.g.dart';

@collection
class Article {
  Id id = Isar.autoIncrement;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  @Index(unique: true)
  late String title;
  late String content;
}
