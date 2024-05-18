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

  Future<void> addTemplate(LlmTemplate template) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await isarDatabase.isar!.writeTxn(() async {
        await isarDatabase.isar!.llmTemplates.put(template);
      });
      final l = state.value!..add(template);
      return l;
    });
  }

  removeTemplate(LlmTemplate template) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await isarDatabase.isar!.writeTxn(() async {
        await isarDatabase.isar!.llmTemplates.delete(template.id);
      });
      final l = state.value!..remove(template);
      return l;
    });
  }
}

final templateNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TemplateNotifier, List<LlmTemplate>>(() {
  return TemplateNotifier();
});
