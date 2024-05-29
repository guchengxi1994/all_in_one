import 'dart:async';

import 'package:all_in_one/isar/article.dart';
import 'package:all_in_one/isar/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class ArticleNotifier extends AutoDisposeAsyncNotifier<List<Article>> {
  final IsarDatabase isarDatabase = IsarDatabase();

  @override
  FutureOr<List<Article>> build() async {
    final articles = await isarDatabase.isar!.articles
        .where()
        .sortByCreateAtDesc()
        .findAll();
    return articles;
  }

  Future<Article?> getLast() async {
    return await isarDatabase.isar!.articles
        .where()
        .sortByCreateAtDesc()
        .findFirst();
  }
}

final articleProvider =
    AutoDisposeAsyncNotifierProvider<ArticleNotifier, List<Article>>(() {
  return ArticleNotifier();
});
