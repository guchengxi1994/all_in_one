// ignore: unused_import
// ignore_for_file: avoid_init_to_null

import 'dart:convert';

import 'package:all_in_one/common/toast_utils.dart';
import 'package:all_in_one/isar/llm_history.dart';
import 'package:all_in_one/isar/llm_template.dart';
import 'package:all_in_one/llm/ai_client.dart';
import 'package:all_in_one/llm/editor/models/datasource.dart';
import 'package:all_in_one/llm/global/components/load_template_dialog.dart';
import 'package:all_in_one/llm/global/components/loading_dialog.dart';
import 'package:all_in_one/llm/global/components/sidemenu.dart';
import 'package:all_in_one/llm/global/components/sidemenu_widget.dart';
import 'package:all_in_one/llm/global/notifiers/loading_dialog_notifier.dart';
import 'package:all_in_one/llm/langchain/notifiers/tool_notifier.dart';
import 'package:all_in_one/llm/plugins/mind_map.dart';
import 'package:all_in_one/llm/plugins/models/mind_map_model.dart';
import 'package:all_in_one/llm/plugins/record/record_utils.dart';
import 'package:all_in_one/llm/template_editor/extension.dart';
import 'package:all_in_one/llm/template_editor/models/chain_flow_state.dart';
import 'package:all_in_one/llm/template_editor/notifiers/chain_flow_notifier.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:uuid/uuid.dart';

import 'editor.dart';
import 'notifiers/editor_notifier.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key, this.enablePlugin = true});
  final bool enablePlugin;

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  // ignore: unused_field
  late EditorState _editorState;
  late WidgetBuilder _widgetBuilder;
  final uuid = const Uuid();
  late String result = "";
  bool isTemplateLoaded = false;
  final AiClient aiClient = AiClient();
  late LlmTemplate? template = null;

  // late Stream<String> toMapStream = mindMapStream();

  @override
  void initState() {
    super.initState();

    _widgetBuilder = (context) => Editor(
          // jsonString: Future(() => _jsonString),
          datasource: Datasource(type: DatasourceType.json, content: ""),
          onEditorStateChange: (editorState) {
            _editorState = editorState;
          },
          showTemplateFeatures: false,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: PlatformExtension.isDesktopOrWeb,
      body: SafeArea(
          child: Row(
        children: [
          Sidemenu(
            items: [
              SidemenuLabel(title: "Article"),
              SidemenuButton(
                icon: Icons.save,
                title: "Save article",
                onTap: () {
                  ref
                      .read(editorNotifierProvider.notifier)
                      .createArticle(
                          _editorState.toStr2().split("\n").firstOrNull ??
                              "unknow-${uuid.v4()}",
                          jsonEncode(_editorState.document.toJson()))
                      .then((_) {
                    ToastUtils.sucess(context, title: "Insert success");
                  }, onError: (_) {
                    ToastUtils.error(context, title: "Insert error");
                  });
                },
              ),
              SidemenuButton(
                icon: Icons.file_open_outlined,
                title: "Load last",
                onTap: () {},
              ),
              SidemenuButton(
                icon: Icons.file_open,
                title: "Load article...",
                onTap: () {},
              ),
              SidemenuDivider(),
              SidemenuLabel(title: "Template"),
              SidemenuButton(
                icon: EvaIcons.file_text,
                title: "Load Template",
                onTap: () async {
                  template = await showGeneralDialog(
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
                            showTemplateFeatures: false,
                          );
                      isTemplateLoaded = true;
                    });

                    Future.delayed(const Duration(milliseconds: 200)).then(
                      (value) {
                        setState(() {
                          _widgetBuilder = (context) => Editor(
                                // jsonString: Future(() => _jsonString),
                                datasource: Datasource(
                                    type: DatasourceType.json,
                                    content: template!.template),
                                onEditorStateChange: (editorState) {
                                  _editorState = editorState;
                                },
                                showTemplateFeatures: false,
                              );
                          isTemplateLoaded = true;
                        });
                      },
                    );
                  }
                },
              ),
              if (isTemplateLoaded)
                SidemenuButton(
                  icon: Bootstrap.file_word,
                  title: "Generate from Template",
                  onTap: () async {
                    if (widget.enablePlugin) {
                      // 存一份数据
                      RecordUtils.putNewMessage(
                          MessageType.query, _editorState.toStr());
                    }
                    ref
                        .read(loadingDialogProvider.notifier)
                        .changeState(LoadingDialogState.format);
                    showGeneralDialog(
                        barrierDismissible: true,
                        barrierColor: Colors.transparent,
                        barrierLabel: "loading-dialog",
                        context: context,
                        pageBuilder: (c, _, __) {
                          return const Center(child: LoadingDialog());
                        });

                    ref.read(chainFlowProvider.notifier).changeContent(
                        jsonEncode(_editorState.document.toJson()));
                    ChainFlowItem item =
                        ChainFlowItem.fromJson(jsonDecode(template!.chains));
                    ref
                        .read(loadingDialogProvider.notifier)
                        .changeState(LoadingDialogState.eval);
                    item.eval(aiClient).then((v) {
                      for (final event in v.entries) {
                        for (final i in _editorState.document.root.children) {
                          if ((i.attributes['delta'] as List).isNotEmpty) {
                            // Node? existsNode = null;
                            Map<String, dynamic>? map = null;
                            for (int j = 0;
                                j < i.attributes['delta'].length;
                                j++) {
                              if (i.attributes['delta'][j]["insert"] != null &&
                                  i.attributes['delta'][j]["insert"]
                                      .contains(event.key)) {
                                map = i.attributes;
                                map['delta'][j]['insert'] =
                                    event.key + event.value.toString();
                              }
                            }
                            if (map != null) {
                              i.updateAttributes(map);
                            }
                          }
                        }
                      }

                      // print("=============================");
                      // print(_editorState.toStr());
                    }).then((_) async {
                      // print("=============================");
                      ref
                          .read(loadingDialogProvider.notifier)
                          .changeState(LoadingDialogState.optimize);

                      final result =
                          await aiClient.optimizeDoc(_editorState.toStr());

                      // print(result.outputAsString);

                      if (result != null) {
                        setState(() {
                          _widgetBuilder = (context) => Editor(
                                // jsonString: Future(() => _jsonString),
                                datasource: Datasource(
                                    type: DatasourceType.markdown,
                                    content: result.outputAsString),
                                onEditorStateChange: (editorState) {
                                  _editorState = editorState;
                                },
                                showTemplateFeatures: false,
                              );
                        });
                      } else {
                        // ignore: use_build_context_synchronously
                        ToastUtils.error(context, title: "Try later");
                      }
                    }).then((_) {
                      ref
                          .read(loadingDialogProvider.notifier)
                          .changeState(LoadingDialogState.done);
                    });
                  },
                ),
              SidemenuDivider(),
              SidemenuLabel(title: "Plugins"),
              SidemenuButton(
                icon: Icons.map,
                title: "Mind map",
                onTap: () {
                  if (_editorState.selection == null) {
                    ToastUtils.error(context, title: "No selection");
                    return;
                  }
                  final text =
                      _editorState.getTextInSelection(_editorState.selection!);

                  if (text.isEmpty) {
                    ToastUtils.error(context, title: "No text selected");
                    return;
                  }
                  result = "";

                  final stream = aiClient.textToMindMap(text.join("\n"));

                  stream.listen(
                    (event) {
                      result += event.outputAsString;
                    },
                    onDone: () {
                      result = result.replaceAll("\n", "");
                      try {
                        MindMapData data =
                            MindMapData.fromJson(jsonDecode(result));
                        showGeneralDialog(
                            barrierColor: Colors.transparent,
                            barrierLabel: "dashboard from map",
                            barrierDismissible: true,
                            context: context,
                            pageBuilder: (c, _, __) {
                              return Center(
                                child: DashboardFromMap(
                                  mindMapData: data,
                                  onAddingToEditor: (p0) {
                                    _editorState.selection ??= Selection.single(
                                        path: [0],
                                        startOffset: 0,
                                        endOffset: 0);
                                    _editorState.insertImageNode(p0);
                                    ToastUtils.sucess(context,
                                        title: "image added");
                                  },
                                ),
                              );
                            });
                      } catch (_) {
                        return;
                      }
                    },
                  );
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
