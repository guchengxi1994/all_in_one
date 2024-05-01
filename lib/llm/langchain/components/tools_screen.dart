import 'dart:convert';

import 'package:all_in_one/llm/langchain/models/tool_model.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tools_item.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  @override
  void initState() {
    super.initState();
    future = loadData();
  }

  // ignore: prefer_typing_uninitialized_variables
  var future;

  String textContent = "";
  loadData() async {
    textContent = await rootBundle.loadString('assets/llm.json');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
          future: future,
          builder: (c, s) {
            if (s.connectionState == ConnectionState.done) {
              final Map<String, dynamic> jsonObj = json.decode(textContent);
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 400),
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
                  Expanded(
                      child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      child: Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        children: jsonObj.entries
                            .map((e) => ToolsItem(
                                  toolModel: ToolModel.fromJson(e.value),
                                ))
                            .toList(),
                      ),
                    ),
                  ))
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
