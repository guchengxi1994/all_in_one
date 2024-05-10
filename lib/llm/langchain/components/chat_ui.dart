import 'package:all_in_one/common/logger.dart';
import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/chatchat/components/input_field.dart';
import 'package:all_in_one/llm/chatchat/models/llm_response.dart';
import 'package:all_in_one/llm/chatchat/models/request_message_box.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/message_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/message_state.dart';
import 'package:all_in_one/llm/langchain/langchain_config.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/src/rust/api/llm_api.dart' as llm;
import 'package:all_in_one/src/rust/llm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatUI extends ConsumerStatefulWidget {
  const ChatUI({super.key});

  @override
  ConsumerState<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends ConsumerState<ChatUI> {
  final llmStream = llm.llmMessageStream();
  final LangchainConfig config = LangchainConfig();

  @override
  void initState() {
    super.initState();
    llmStream.listen((event) {
      // print(event.content);

      if (event.content == "!over!") {
        final last = ref.read(messageProvider).messageBox.last;
        ref.read(historyProvider(LLMType.chatchat).notifier).updateHistory(
            id, last.content, MessageType.response,
            roleType: event.type);
      } else {
        final res = LLMResponse(messageId: event.uuid, text: event.content);
        ref.read(messageProvider.notifier).updateMessageBox(res);
      }
    });
  }

  late int id = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        while (ref.read(historyProvider(LLMType.openai)).value == null) {
          await Future.delayed(const Duration(milliseconds: 10));
        }

        id = ref.watch(historyProvider(LLMType.openai)).value!.current;
      }
    });

    return Container(
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
              showUploadFileButton: false,
              onSubmit: (s) => _handleInputMessage(s, state))
        ],
      ),
    );
  }

  _handleInputMessage(String s, MessageState state) async {
    if (state.isLoading) {
      return;
    }
    final model = ref.read(toolProvider);

    ref
        .read(messageProvider.notifier)
        .addMessageBox(RequestMessageBox(content: s));
    if (id == 0) {
      await ref.read(historyProvider(LLMType.openai).notifier).newHistory(s,
          chatTag: model == null || model.toMessage().content == "normal"
              ? "随便聊聊"
              : model.name);

      id = ref.read(historyProvider(LLMType.openai)).value!.current;
    }

    // 根据id获取 config中定义的history长度的message
    final messages = ref
        .read(historyProvider(LLMType.openai).notifier)
        .getMessages(config.historyLength, id);

    List<LLMMessage> history;
    if (model != null && model.toMessage().content != "normal") {
      history = [
        model.toMessage(),
        ...messages.map((e) =>
            LLMMessage(uuid: "", content: e.content ?? "", type: e.roleType))
      ];
    } else {
      history = messages
          .map((e) =>
              LLMMessage(uuid: "", content: e.content ?? "", type: e.roleType))
          .toList();
    }

    for (final i in history) {
      logger.info("${i.type} ${i.content}");
    }

    ref
        .read(historyProvider(LLMType.openai).notifier)
        .updateHistory(id, s, MessageType.query);
    llm.chat(stream: true, query: s, history: history);
  }
}
