import 'dart:convert';

import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/chatchat_config.dart';
import 'package:all_in_one/llm/chatchat/models/error_message_box.dart';
import 'package:all_in_one/llm/chatchat/models/knowledge_base_chat_response.dart';
import 'package:all_in_one/llm/chatchat/models/llm_response.dart';
import 'package:all_in_one/llm/chatchat/models/request_message_box.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/message_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/message_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'input_field.dart';

class ChatUI extends ConsumerStatefulWidget {
  const ChatUI({super.key, required this.config});
  final ChatchatConfig config;

  @override
  ConsumerState<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends ConsumerState<ChatUI> {
  @override
  void dispose() {
    super.dispose();
  }

  late int id = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        while (ref.read(historyProvider(LLMType.chatchat)).value == null) {
          await Future.delayed(const Duration(milliseconds: 10));
        }

        id = ref.watch(historyProvider(LLMType.chatchat)).value!.current;
      }
    });

    return Container(
      // color: Colors.white,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(255, 245, 245, 247),
            Color.fromARGB(255, 233, 237, 248)
          ])),
      child: Column(
        children: [
          Flexible(
              child: SizedBox.expand(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller:
                      ref.read(messageProvider.notifier).scrollController,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children:
                        state.messageBox.map((e) => e.toWidget()).toList(),
                  ),
                ),
                if (state.isLoading)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.withAlpha(75),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          LoadingAnimationWidget.flickr(
                            leftDotColor: const Color(0xFF1A1A3F),
                            rightDotColor: const Color(0xFFEA3799),
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("回答中...")
                        ],
                      ),
                    ),
                  )
              ],
            ),
          )),
          InputField(
              showUploadFileButton: true,
              onChain: (p0) async {},
              onFileSelected: (p0) async {},
              onSubmit: (s) => _handleInputMessage(s, state))
        ],
      ),
    );
  }

  _handleInputMessage(String s, MessageState state) async {
    // print(s);
    if (state.isLoading) {
      return;
    }

    ref
        .read(messageProvider.notifier)
        .addMessageBox(RequestMessageBox(content: s));

    if (id == 0) {
      await ref.read(historyProvider(LLMType.chatchat).notifier).newHistory(s);

      id = ref.read(historyProvider(LLMType.chatchat)).value!.current;
    }

    ref
        .read(historyProvider(LLMType.chatchat).notifier)
        .updateHistory(id, s, MessageType.query);

    if (widget.config.stream) {
      final r = await widget.config
          .getLLMResponse(s, isKnowledgeBase: state.isKnowledgeBaseChat);
      r.data.stream.listen((List<int> event) {
        ref.read(messageProvider.notifier).setLoading(true);
        try {
          if (!state.isKnowledgeBaseChat) {
            final data = utf8.decode(event).replaceFirst("data:", "");
            final res = LLMResponse.fromJson(jsonDecode(data));
            ref.read(messageProvider.notifier).updateMessageBox(res);
          } else {
            final data = utf8.decode(event).replaceFirst("data:", "");
            final res = KnowledgeBaseChatResponse.fromJson(jsonDecode(data));
            // ref.read(messageProvider.notifier).updateMessageBox(res);
            print(res.toJson());
            ref
                .read(messageProvider.notifier)
                .updateKnowledgeBaseChatMessageBox(res,
                    isDone: res.answer == null && (res.docs ?? []).isNotEmpty);
          }
        } catch (_) {}
      }, onDone: () {
        ref.read(messageProvider.notifier).setLoading(false);
        final last = ref.read(messageProvider).messageBox.last;

        ref
            .read(historyProvider(LLMType.chatchat).notifier)
            .updateHistory(id, last.content, MessageType.response);
      }, onError: (e) {
        if (kDebugMode) {
          print("error ${e.toString()}");
        }
        ref.read(messageProvider.notifier).setLoading(false);
        ref
            .read(messageProvider.notifier)
            .addMessageBox(ErrorMessageBox(content: ""));
      });
    }

    ref.read(messageProvider.notifier).jumpToMax();
  }
}
