import 'package:all_in_one/layout/components/animated_sidebar.dart';
import 'package:all_in_one/layout/notifiers/page_notifier.dart';
import 'package:all_in_one/layout/styles.dart';
import 'package:all_in_one/llm/langchain/langchain_chat_screen.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:all_in_one/tool_entry/entry_screen.dart';
import 'package:all_in_one/workboard/workboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Layout extends ConsumerStatefulWidget {
  const Layout({super.key});

  @override
  ConsumerState<Layout> createState() => _LayoutState();
}

class _LayoutState extends ConsumerState<Layout> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: LayoutStyle.duration),
    vsync: this,
  );

  late final Animation<double> _animation =
      Tween<double>(begin: 1.0, end: 0.95).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedSidebar(
            outerController: _controller,
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppStyle.bluishGrey, Colors.white])),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ScaleTransition(
                scale: _animation,
                child: PageView(
                  controller: ref.read(pageProvider.notifier).pageController,
                  children: const [
                    WorkboardScreen(),
                    EntryScreen(),
                    LangchainChatScreen()
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
