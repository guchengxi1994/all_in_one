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

  Future newHistory(String title, {String chatTag = "随便聊聊"}) async {
    LLMHistory history = LLMHistory()
      ..title = title
      ..chatTag = chatTag;

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
      final suggestions = total.map((e) => e.title ?? "").toList()..remove("");
      return HistoryState(
          history: total, current: history.id, suggestions: suggestions);
    });
  }

  Future updateHistory(int id, String content, MessageType messageType,
      {int? roleType}) async {
    final history =
        await database.isar!.lLMHistorys.where().idEqualTo(id).findFirst();
    if (history == null) {
      return;
    }

    LLMHistoryMessage messages = LLMHistoryMessage()
      ..content = content
      ..messageType = messageType
      ..roleType = roleType ?? 0;

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
      final suggestions = total.map((e) => e.title ?? "").toList()..remove("");
      return HistoryState(history: total, current: 0, suggestions: suggestions);
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
      final suggestions =
          state.value!.history.map((e) => e.title ?? "").toList()..remove("");
      return HistoryState(
          history: state.value!.history, current: id, suggestions: suggestions);
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

    final suggestions = history.map((e) => e.title ?? "").toList()..remove("");

    return HistoryState(history: history, suggestions: suggestions);
  }

  List<LLMHistoryMessage> getMessages(int length, int id) {
    final history =
        database.isar!.lLMHistorys.where().idEqualTo(id).findFirstSync();
    if (history == null) {
      return [];
    }

    int count = history.messages.length - 3;

    final messages = history.messages.toList().sublist(count < 0 ? 0 : count);
    return messages;
  }
}

final historyProvider = AutoDisposeAsyncNotifierProvider.family<HistoryNotifier,
    HistoryState, LLMType>(() => HistoryNotifier());
