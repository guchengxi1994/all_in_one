import 'package:all_in_one/llm/chatchat/components/input_field.dart';
import 'package:all_in_one/src/rust/api/llm_api.dart' as llm;
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

  @override
  void initState() {
    super.initState();
    llmStream.listen((event) {
      print(event.content);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                SingleChildScrollView(),
                if (1 == 2)
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
              onSubmit: (s) => _handleInputMessage(s))
        ],
      ),
    );
  }

  _handleInputMessage(String s) {
    // chat
    llm.chat(stream: true, query: s);
  }
}
