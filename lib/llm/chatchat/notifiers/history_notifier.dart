import 'dart:async';

import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/llm_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'history_state.dart';
import 'message_notifier.dart';

class HistoryNotifier
    extends AutoDisposeFamilyAsyncNotifier<HistoryState, LLMType> {
  final IsarDatabase database = IsarDatabase();

  Future newHistory(String title) async {
    LLMHistory history = LLMHistory()..title = title;

    await database.isar!.writeTxn(() async {
      await database.isar!.lLMHistorys.put(history);
    });

    state = await AsyncValue.guard(() async {
      final total = await database.isar!.lLMHistorys
          .filter()
          .llmTypeEqualTo(arg)
          .offset(0)
          .limit(30)
          .findAll();
      return HistoryState(history: total, current: history.id);
    });
  }

  Future updateHistory(int id, String content, MessageType messageType) async {
    final history =
        await database.isar!.lLMHistorys.where().idEqualTo(id).findFirst();
    if (history == null) {
      return;
    }

    LLMHistoryMessages messages = LLMHistoryMessages()
      ..content = content
      ..messageType = messageType;

    await database.isar!.writeTxn(() async {
      await database.isar!.lLMHistoryMessages.put(messages);
      history.messages.add(messages);
      await history.messages.save();
    });
  }

  delete(int id) async {
    await database.isar!.writeTxn(() async {
      await database.isar!.lLMHistorys.delete(id);
    });

    state = await AsyncValue.guard(() async {
      final total = await database.isar!.lLMHistorys
          .filter()
          .llmTypeEqualTo(arg)
          .offset(0)
          .limit(30)
          .findAll();
      return HistoryState(history: total, current: 0);
    });
  }

  refresh(int id) async {
    final history =
        await database.isar!.lLMHistorys.where().idEqualTo(id).findFirst();
    if (history == null) {
      return;
    }

    if (ref.read(messageProvider).isLoading) {
      return;
    }

    ref.read(messageProvider.notifier).refresh(history.messages.toList());

    state = await AsyncValue.guard(() async {
      return HistoryState(history: state.value!.history, current: id);
    });
  }

  @override
  FutureOr<HistoryState> build(LLMType arg) async {
    final history = await database.isar!.lLMHistorys
        .filter()
        .llmTypeEqualTo(arg)
        .offset(0)
        .limit(30)
        .findAll();

    return HistoryState(history: history);
  }
}

final historyProvider = AutoDisposeAsyncNotifierProvider.family<HistoryNotifier,
    HistoryState, LLMType>(() => HistoryNotifier());
