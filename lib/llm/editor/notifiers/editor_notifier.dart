import 'dart:async';

import 'package:all_in_one/isar/article.dart';
import 'package:all_in_one/isar/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class EditorNotifier extends AutoDisposeAsyncNotifier {
  final IsarDatabase isarDatabase = IsarDatabase();

  @override
  FutureOr build() {
    return null;
  }

  Future createArticle(String title, String content) async {
    try {
      await isarDatabase.isar!.writeTxn(() async {
        await isarDatabase.isar!.articles.put(Article()
          ..title = title
          ..content = content);
      });
    } catch (e) {
      throw Exception("insert error");
    }
  }

  Future updateArticle(Article article) async {
    await isarDatabase.isar!.writeTxn(() async {
      await isarDatabase.isar!.articles.put(article);
    });
  }

  Future deleteArticle(Article article) async {
    await isarDatabase.isar!.writeTxn(() async {
      await isarDatabase.isar!.articles.delete(article.id);
    });
  }

  Future<List<Article>> getArticles() async {
    return await isarDatabase.isar!.articles.where().findAll();
  }

  Future<Article?> getArticle(Id id) async {
    return await isarDatabase.isar!.articles.get(id);
  }

  Future<void> deleteAllArticles() async {
    await isarDatabase.isar!.writeTxn(() async {
      await isarDatabase.isar!.articles.clear();
    });
  }
}

final editorNotifierProvider =
    AutoDisposeAsyncNotifierProvider<EditorNotifier, void>(() {
  return EditorNotifier();
});
