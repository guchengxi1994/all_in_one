import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/llm_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class TemplateNotifier extends AutoDisposeAsyncNotifier<List<LlmTemplate>> {
  final IsarDatabase isarDatabase = IsarDatabase();

  @override
  Future<List<LlmTemplate>> build() async {
    final templates = await isarDatabase.isar!.llmTemplates.where().findAll();
    return templates;
  }

  Future<int> addTemplate(LlmTemplate template, {int id = 0}) async {
    state = const AsyncLoading();

    if (id != 0) {
      template.id = id;
    }

    state = await AsyncValue.guard(() async {
      await isarDatabase.isar!.writeTxn(() async {
        await isarDatabase.isar!.llmTemplates.put(template);
      });
      final l = List<LlmTemplate>.from(state.value!)..add(template);
      return l;
    });

    return template.id;
  }

  removeTemplate(LlmTemplate template) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await isarDatabase.isar!.writeTxn(() async {
        await isarDatabase.isar!.llmTemplates.delete(template.id);
      });
      final l = List<LlmTemplate>.from(state.value!)..remove(template);
      return l;
    });
  }
}

final templateNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TemplateNotifier, List<LlmTemplate>>(() {
  return TemplateNotifier();
});
