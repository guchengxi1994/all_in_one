import 'package:all_in_one/common/logger.dart';
import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/llm/ai_client.dart';
import 'package:all_in_one/llm/chatchat/components/input_field.dart';
import 'package:all_in_one/llm/chatchat/models/llm_response.dart';
import 'package:all_in_one/llm/chatchat/models/request_message_box.dart';
import 'package:all_in_one/llm/chatchat/notifiers/history_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/message_notifier.dart';
import 'package:all_in_one/llm/chatchat/notifiers/message_state.dart';
import 'package:all_in_one/llm/langchain/langchain_config.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
// import 'package:all_in_one/src/rust/api/llm_api.dart' as llm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:langchain_lib/langchain_lib.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';

class ChatUI extends ConsumerStatefulWidget {
  const ChatUI({super.key, required this.chatTag});
  final String chatTag;

  @override
  ConsumerState<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends ConsumerState<ChatUI> {
  // final llmStream = llm.llmMessageStream();
  final LangchainConfig config = LangchainConfig();
  final AiClient aiClient = AiClient();

  @override
  void initState() {
    super.initState();
  }

  late int id = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        while (
            ref.read(historyProvider((LLMType.openai, widget.chatTag))).value ==
                null) {
          await Future.delayed(const Duration(milliseconds: 10));
        }

        id = ref
            .watch(historyProvider((LLMType.openai, widget.chatTag)))
            .value!
            .current;
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
    String uuid = const Uuid().v4();

    if (aiClient.client == null) {
      return;
    }

    if (state.isLoading) {
      return;
    }
    final model = ref.read(toolProvider);

    ref
        .read(messageProvider.notifier)
        .addMessageBox(RequestMessageBox(content: s));
    if (id == 0) {
      await ref
          .read(historyProvider((LLMType.openai, widget.chatTag)).notifier)
          .newHistory(s, chatTag: widget.chatTag);

      id = ref
          .read(historyProvider((LLMType.openai, widget.chatTag)))
          .value!
          .current;
    }

    // 根据id获取 config中定义的history长度的message
    final messages = ref
        .read(historyProvider((LLMType.openai, widget.chatTag)).notifier)
        .getMessages(config.historyLength, id);

    List<ChatMessage> history = messages.map((v) {
      if (v.roleType == 0) {
        return MessageUtil.createHumanMessage(v.content ?? "");
      } else if (v.roleType == 1) {
        return MessageUtil.createSystemMessage(v.content ?? "");
      } else if (v.roleType == 2) {
        return MessageUtil.createAiMessage(v.content ?? "");
      } else {
        return MessageUtil.createToolMessage(v.content ?? "", "");
      }
    }).toList();

    if (model != null && model.toMessage()!.content != "normal") {
      history.insert(0, MessageUtil.createSystemMessage(model.systemPrompt));
    }

    for (final i in history) {
      logger.info(i.contentAsString);
    }

    history.add(MessageUtil.createHumanMessage(s));

    ref
        .read(historyProvider((LLMType.openai, widget.chatTag)).notifier)
        .updateHistory(id, s, MessageType.query);
    final Stream<ChatResult> stream = aiClient.client!.stream(history);

    stream.listen(
      (event) {
        final res = LLMResponse(messageId: uuid, text: event.outputAsString);
        ref.read(messageProvider.notifier).updateMessageBox(res);
      },
      onDone: () {
        final last = ref.read(messageProvider).messageBox.last;
        ref
            .read(historyProvider((LLMType.chatchat, widget.chatTag)).notifier)
            .updateHistory(id, last.content, MessageType.response, roleType: 2);
      },
    );
  }
}
