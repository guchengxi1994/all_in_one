import 'dart:convert';

import 'package:all_in_one/llm/langchain/models/tool_model.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tools_item.dart';

class ToolsScreen extends ConsumerStatefulWidget {
  const ToolsScreen({super.key});

  @override
  ConsumerState<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends ConsumerState<ToolsScreen> {
  @override
  void initState() {
    super.initState();
    future = loadData();
    controller.addListener(() {
      if (controller.offset >= 200) {
        setState(() {
          showTitle = true;
        });
      } else {
        setState(() {
          showTitle = false;
        });
      }
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  var future;

  String textContent = "";
  loadData() async {
    textContent = await rootBundle.loadString('assets/llm.json');
  }

  final ScrollController controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool showTitle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
            future: future,
            builder: (c, s) {
              if (s.connectionState == ConnectionState.done) {
                final Map<String, dynamic> jsonObj = json.decode(textContent);

                return NestedScrollView(
                    controller: controller,
                    headerSliverBuilder: (ctx, _) {
                      return [
                        SliverAppBar(
                          surfaceTintColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          expandedHeight: 400.0,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            title: showTitle
                                // ? const SizedBox(
                                //     height: 50,
                                //     child: Align(
                                //       alignment: Alignment.centerRight,
                                //       child: Text(
                                //         "😃 Have a nice day.",
                                //         style: TextStyle(
                                //             fontFamily: "xing",
                                //             fontSize: 30,
                                //             color: AppStyle.black),
                                //       ),
                                //     ),
                                //   )
                                ? SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text("😃"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        AnimatedTextKit(
                                          isRepeatingAnimation: true,
                                          animatedTexts: [
                                            ColorizeAnimatedText(
                                              "Have a nice day.",
                                              textStyle: const TextStyle(
                                                fontFamily: "xing",
                                                fontSize: 30.0,
                                              ),
                                              colors: [
                                                Colors.purple,
                                                Colors.blue,
                                                Colors.yellow,
                                                Colors.red,
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : null,
                            background: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  constraints:
                                      const BoxConstraints(maxHeight: 400),
                                  child: Image.asset(
                                    "assets/llm/banner.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    bottom: 40,
                                    right: 20,
                                    child: Transform.rotate(
                                      angle: -3.14 / 10,
                                      child: const Text(
                                        "Let AI help you",
                                        style: TextStyle(
                                            fontFamily: "xing",
                                            fontSize: 40,
                                            color: AppStyle.orange),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )
                      ];
                    },
                    body: _wrapper2(
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showTitle)
                                const SizedBox(
                                  height: 60,
                                ),
                              const SizedBox(
                                width: double.infinity,
                                height: 35,
                                child: Text(
                                  "AI Compose",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Wrap(
                                runSpacing: 15,
                                spacing: 15,
                                children: jsonObj.entries
                                    .where((e) => e.value["type"] == "compose")
                                    .map((e) {
                                  return ToolsItem(
                                    onTap: () {
                                      if (e.key == "template") {
                                        ref
                                            .read(toolProvider.notifier)
                                            .jumpTo(3);
                                      }
                                      if (e.key == "compose") {
                                        ref
                                            .read(toolProvider.notifier)
                                            .jumpTo(4);
                                      }
                                    },
                                    toolModel: ToolModel.fromJson(e.value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 35,
                                child: Text(
                                  "AI Tools",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Wrap(
                                runSpacing: 15,
                                spacing: 15,
                                children: jsonObj.entries
                                    .where((e) => e.value["type"] == "tool")
                                    .map((e) => ToolsItem(
                                          toolModel:
                                              ToolModel.fromJson(e.value),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        context));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  Widget _wrapper2(Widget c, BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context)
          .copyWith(scrollbars: false, dragDevices: {}),
      child: c, //嵌套你的SingleChildScrollView组件
    );
  }
}
