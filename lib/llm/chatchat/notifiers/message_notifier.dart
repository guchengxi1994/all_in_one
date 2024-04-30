import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/models/knowledge_base_chat_message_box.dart';
import 'package:all_in_one/llm/chatchat/models/knowledge_base_chat_response.dart';
import 'package:all_in_one/llm/chatchat/models/llm_response.dart';
import 'package:all_in_one/llm/chatchat/models/message_box.dart';
import 'package:all_in_one/llm/chatchat/models/request_message_box.dart';
import 'package:all_in_one/llm/chatchat/models/response_message_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'message_state.dart';

class MessageNotifier extends AutoDisposeNotifier<MessageState> {
  final ScrollController scrollController = ScrollController();

  @override
  MessageState build() {
    return MessageState(isKnowledgeBaseChat: true);
  }

  changeKnowledgeBaseChat(bool b) {
    if (state.isKnowledgeBaseChat != b) {
      state = MessageState(isKnowledgeBaseChat: b);
    }
  }

  addMessageBox(MessageBox box) {
    if (state.isLoading) {
      return;
    }

    final l = List<MessageBox>.from(state.messageBox)..add(box);

    state = MessageState(
        messageBox: l,
        isLoading: state.isLoading,
        isKnowledgeBaseChat: state.isKnowledgeBaseChat);

    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  jumpToMax() {
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  updateMessageBox(LLMResponse response) {
    final box = state.messageBox
        .where((element) =>
            element is ResponseMessageBox && element.id == response.messageId)
        .firstOrNull;

    if (box != null) {
      final l = List<MessageBox>.from(state.messageBox)..remove(box);
      box.content += response.text ?? "";
      state = MessageState(
          messageBox: l..add(box),
          isLoading: state.isLoading,
          isKnowledgeBaseChat: state.isKnowledgeBaseChat);
    } else {
      final l = List<MessageBox>.from(state.messageBox)
        ..add(ResponseMessageBox(
            content: response.text ?? "", id: response.messageId!));
      state = MessageState(
          isLoading: state.isLoading,
          messageBox: l,
          isKnowledgeBaseChat: state.isKnowledgeBaseChat);
    }

    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  updateKnowledgeBaseChatMessageBox(KnowledgeBaseChatResponse response,
      {bool isDone = false}) {
    final box =
        state.messageBox.whereType<KnowledgeBaseChatMessageBox>().lastOrNull;

    if (box == null || box.isDone) {
      // 新建
      final l = List<MessageBox>.from(state.messageBox)
        ..add(KnowledgeBaseChatMessageBox(
            content: response.answer ?? "", docs: response.docs ?? []));
      state = MessageState(
          isLoading: state.isLoading,
          messageBox: l,
          isKnowledgeBaseChat: state.isKnowledgeBaseChat);
    } else {
      // 更新
      final l = List<MessageBox>.from(state.messageBox)..remove(box);
      box.content += response.answer ?? "";
      box.docs = response.docs ?? [];
      box.isDone = isDone;
      state = MessageState(
          messageBox: l..add(box),
          isLoading: state.isLoading,
          isKnowledgeBaseChat: state.isKnowledgeBaseChat);
    }

    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  setLoading(bool b) {
    if (b != state.isLoading) {
      state = MessageState(
          messageBox: state.messageBox,
          isLoading: b,
          isKnowledgeBaseChat: state.isKnowledgeBaseChat);
    }
  }

  refresh(List<LLMHistoryMessage> messages) {
    if (state.isLoading) {
      return;
    }

    List<MessageBox> boxes = [];
    for (final i in messages) {
      if (i.messageType == MessageType.query) {
        boxes.add(RequestMessageBox(content: i.content ?? ""));
      } else {
        boxes.add(ResponseMessageBox(
            content: i.content ?? "", id: "history_${i.id}"));
      }
    }

    state = MessageState(
        messageBox: boxes,
        isLoading: false,
        isKnowledgeBaseChat: state.isKnowledgeBaseChat);
  }
}

final messageProvider =
    AutoDisposeNotifierProvider<MessageNotifier, MessageState>(
  () => MessageNotifier(),
);
