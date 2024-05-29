// ignore_for_file: unused_field, avoid_init_to_null, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:all_in_one/common/toast_utils.dart';
import 'package:all_in_one/isar/llm_template.dart';
import 'package:all_in_one/llm/global/components/load_template_dialog.dart';
import 'package:all_in_one/llm/global/components/sidemenu.dart';
import 'package:all_in_one/llm/global/components/sidemenu_widget.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/llm/template_editor/components/chain_flow.dart';
import 'package:all_in_one/llm/editor/models/datasource.dart';
import 'package:all_in_one/llm/template_editor/extension.dart';
import 'package:all_in_one/llm/template_editor/notifiers/chain_flow_notifier.dart';
import 'package:all_in_one/llm/template_editor/notifiers/template_notifier.dart';
// import 'package:all_in_one/src/rust/api/llm_api.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../editor/editor.dart';
import 'components/new_template_dialog.dart';

/* eg.
    这是一份kimi介绍。 
    {{ 介绍一下你自己 }}
    {{ 总结到100字以内 }}
    =================================================
   {{ 帮我生成一份rust学习清单 }}
   {{ 根据清单内容梳理难点 }}
*/
class TemplateEditor extends ConsumerStatefulWidget {
  const TemplateEditor({super.key, this.enablePlugin = true});
  final bool enablePlugin;

  @override
  ConsumerState<TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends ConsumerState<TemplateEditor> {
  late EditorState _editorState;
  late String _jsonString;
  late WidgetBuilder _widgetBuilder;
  late int currentTemplateId = 0;
  late String currentTemplateName = "";

  // final stream = templateMessageStream();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(chainFlowProvider.notifier).clear();
    });

    _jsonString = jsonEncode({
      "document": {
        "type": "page",
        "children": [
          {
            "type": "heading",
            "data": {
              "level": 2,
              "delta": [
                {
                  "insert": "👋 欢迎使用模板编辑器",
                  "attributes": {"bold": true, "italic": false}
                },
              ],
              "align": "center"
            }
          }
        ]
      }
    });
    _widgetBuilder = (context) => Editor(
          // jsonString: Future(() => _jsonString),
          datasource:
              Datasource(type: DatasourceType.json, content: _jsonString),
          onEditorStateChange: (editorState) {
            _editorState = editorState;
          },
          showTemplateFeatures: true,
        );
  }

  final GlobalKey<ScaffoldState> key = GlobalKey();
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      endDrawer: const ChainFlow(),
      extendBodyBehindAppBar: PlatformExtension.isDesktopOrWeb,
      body: SafeArea(
          child: Row(
        children: [
          Sidemenu(
            items: [
              SidemenuLabel(title: "Template"),
              SidemenuButton(
                icon: EvaIcons.file_text,
                title: "Load Template",
                onTap: () async {
                  final LlmTemplate? template = await showGeneralDialog(
                      barrierColor: Colors.transparent,
                      barrierDismissible: true,
                      barrierLabel: "load-template",
                      context: context,
                      pageBuilder: (c, _, __) {
                        return const Center(
                          child: LoadTemplateDialog(),
                        );
                      });

                  if (template != null) {
                    setState(() {
                      _widgetBuilder = (context) => Editor(
                            // jsonString: Future(() => _jsonString),
                            datasource: Datasource(
                                type: DatasourceType.json, content: ""),
                            onEditorStateChange: (editorState) {
                              _editorState = editorState;
                            },
                            showTemplateFeatures: true,
                          );
                    });

                    Future.delayed(const Duration(milliseconds: 200)).then(
                      (value) {
                        setState(() {
                          _widgetBuilder = (context) => Editor(
                                // jsonString: Future(() => _jsonString),
                                datasource: Datasource(
                                    type: DatasourceType.json,
                                    content: template.template),
                                onEditorStateChange: (editorState) {
                                  _editorState = editorState;
                                },
                                showTemplateFeatures: true,
                              );
                        });
                      },
                    );
                  }
                },
              ),
              SidemenuButton(
                icon: EvaIcons.save,
                title: "Save Template",
                onTap: () async {
                  // print(jsonEncode(ref.read(chainFlowProvider).items.toJson()));
                  final itemStr =
                      jsonEncode(ref.read(chainFlowProvider).items.toJson());

                  if (currentTemplateId != 0) {
                    ref
                        .read(templateNotifierProvider.notifier)
                        .addTemplate(
                            LlmTemplate()
                              ..templateContent = _editorState.toStr2()
                              ..chains = itemStr
                              ..template =
                                  jsonEncode(_editorState.document.toJson())
                              ..name = currentTemplateName,
                            id: currentTemplateId)
                        .then((v) {
                      currentTemplateId = v;
                      currentTemplateName = currentTemplateName;
                      ToastUtils.sucess(context, title: "Template created!");
                    });
                  } else {
                    final String? r = await showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.transparent,
                        barrierLabel: "new-template",
                        pageBuilder: (c, _, __) {
                          return const Center(
                            child: NewTemplateDialog(),
                          );
                        });

                    if (r != null) {
                      ref
                          .read(templateNotifierProvider.notifier)
                          .addTemplate(
                              LlmTemplate()
                                ..templateContent = _editorState.toStr2()
                                ..chains = itemStr
                                ..template =
                                    jsonEncode(_editorState.document.toJson())
                                ..name = r,
                              id: currentTemplateId)
                          .then((v) {
                        currentTemplateId = v;
                        currentTemplateName = r;
                        ToastUtils.sucess(context, title: "Template created!");
                      });
                    }
                  }
                },
              ),
              SidemenuDivider(),
              SidemenuLabel(title: "Chain"),
              SidemenuButton(
                icon: Bootstrap.magic,
                title: "Chain designer",
                onTap: () {
                  ref.read(chainFlowProvider.notifier).changeContent(
                      jsonEncode(_editorState.document.toJson()));

                  showGeneralDialog(
                      context: context,
                      barrierColor: Colors.transparent,
                      barrierLabel: "chain-flow",
                      barrierDismissible: true,
                      pageBuilder: (c, _, __) {
                        return const Center(
                          child: ChainFlowDesigner(),
                        );
                      });
                },
              ),
              SidemenuButton(
                icon: Bootstrap.view_stacked,
                title: "Chain viewer",
                onTap: () {
                  if (ref.read(chainFlowProvider).items.flowItems.isEmpty) {
                    return;
                  }

                  if (key.currentState!.isEndDrawerOpen) {
                    key.currentState!.closeEndDrawer();
                  } else {
                    key.currentState!.openEndDrawer();
                  }
                },
              ),
              SidemenuDivider(),
            ],
            footer: SidemenuButton(
              icon: Icons.chevron_left,
              title: "Back",
              onTap: () {
                ref.read(toolProvider.notifier).jumpTo(0);
              },
            ),
          ),
          Expanded(child: _widgetBuilder(context))
        ],
      )),
    );
  }
}
