// ignore_for_file: non_constant_identifier_names

import 'package:all_in_one/llm/ai_client.dart';
import 'package:all_in_one/llm/editor/notifiers/ai_generate_config_notifier.dart';
// import 'package:all_in_one/src/rust/api/llm_api.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:langchain_lib/langchain_lib.dart';

import 'add_tag_button.dart';
import 'dropdown_button.dart';

class AiMenu extends SelectionMenuService {
  AiMenu({
    required this.context,
    required this.editorState,
    this.style = SelectionMenuStyle.light,
  });
  final EditorState editorState;
  final BuildContext context;
  OverlayEntry? _AiMenuEntry;
  bool _selectionUpdateByInner = false;
  Offset _offset = Offset.zero;
  Alignment _alignment = Alignment.topLeft;

  @override
  final SelectionMenuStyle style;

  @override
  Alignment get alignment => _alignment;

  @override
  void dismiss() {
    if (_AiMenuEntry != null) {
      editorState.service.keyboardService?.enable();
      editorState.service.scrollService?.enable();
    }

    _AiMenuEntry?.remove();
    _AiMenuEntry = null;

    // workaround: SelectionService has been released after hot reload.
    final isSelectionDisposed =
        editorState.service.selectionServiceKey.currentState == null;
    if (!isSelectionDisposed) {
      final selectionService = editorState.service.selectionService;
      // focus to reload the selection after the menu dismissed.
      editorState.selection = editorState.selection;
      selectionService.currentSelection.removeListener(_onSelectionChange);
    }
  }

  void _onSelectionChange() {
    // workaround: SelectionService has been released after hot reload.
    final isSelectionDisposed =
        editorState.service.selectionServiceKey.currentState == null;
    if (!isSelectionDisposed) {
      final selectionService = editorState.service.selectionService;
      if (selectionService.currentSelection.value == null) {
        return;
      }
    }

    if (_selectionUpdateByInner) {
      _selectionUpdateByInner = false;
      return;
    }

    dismiss();
  }

  void _show() {
    dismiss();

    final selectionService = editorState.service.selectionService;
    final selectionRects = selectionService.selectionRects;
    if (selectionRects.isEmpty) {
      return;
    }

    calculateSelectionMenuOffset(selectionRects.first);
    final (left, top, right, bottom) = getPosition();

    final editorHeight = editorState.renderBox!.size.height;
    final editorWidth = editorState.renderBox!.size.width;

    _AiMenuEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
          width: editorWidth,
          height: editorHeight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              dismiss();
            },
            child: Stack(
              children: [
                Positioned(
                  top: top,
                  bottom: bottom,
                  left: left,
                  right: right,
                  child: AiMenuWidget(
                    onSubmit: (p0) async {
                      await editorState
                          .insertTextAtCurrentSelection(p0)
                          .then((_) {
                        dismiss();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_AiMenuEntry!);

    editorState.service.keyboardService?.disable(showCursor: true);
    editorState.service.scrollService?.disable();
    selectionService.currentSelection.addListener(_onSelectionChange);
  }

  @override
  (double?, double?, double?, double?) getPosition() {
    double? left, top, right, bottom;
    switch (alignment) {
      case Alignment.topLeft:
        left = offset.dx;
        top = offset.dy;
        break;
      case Alignment.bottomLeft:
        left = offset.dx;
        bottom = offset.dy;
        break;
      case Alignment.topRight:
        right = offset.dx;
        top = offset.dy;
        break;
      case Alignment.bottomRight:
        right = offset.dx;
        bottom = offset.dy;
        break;
    }

    return (left, top, right, bottom);
  }

  @override
  Offset get offset {
    return _offset;
  }

  @override
  void show() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _show();
    });
  }

  void calculateSelectionMenuOffset(Rect rect) {
    // Workaround: We can customize the padding through the [EditorStyle],
    // but the coordinates of overlay are not properly converted currently.
    // Just subtract the padding here as a result.
    const menuHeight = 200.0;
    const menuOffset = Offset(0, 10);
    final editorOffset =
        editorState.renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final editorHeight = editorState.renderBox!.size.height;
    final editorWidth = editorState.renderBox!.size.width;

    // show below default
    _alignment = Alignment.topLeft;
    final bottomRight = rect.bottomRight;
    final topRight = rect.topRight;
    var offset = bottomRight + menuOffset;
    _offset = Offset(
      offset.dx,
      offset.dy,
    );

    // show above
    if (offset.dy + menuHeight >= editorOffset.dy + editorHeight) {
      offset = topRight - menuOffset;
      _alignment = Alignment.bottomLeft;

      _offset = Offset(
        offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      );
    }

    // show on left
    if (_offset.dx - editorOffset.dx > editorWidth / 2) {
      _alignment = _alignment == Alignment.topLeft
          ? Alignment.topRight
          : Alignment.bottomRight;

      _offset = Offset(
        editorWidth - _offset.dx + editorOffset.dx,
        _offset.dy,
      );
    }
  }
}

AiMenu? _AiMenu;
Future showAiMenu(
  EditorState editorState,
) async {
  final selection = editorState.selection;
  if (selection == null) {
    return;
  }

  // delete the selection
  if (!selection.isCollapsed) {
    await editorState.deleteSelection(selection);
  }
  // final afterSelection = editorState.selection;
// show the slash menu
  () {
    // this code is copied from the the old editor.
    final context = editorState.getNodeAtPath(selection.start.path)?.context;
    if (context != null) {
      _AiMenu = AiMenu(context: context, editorState: editorState);
      _AiMenu?.show();
    }
  }();
}

typedef OnSubmit = void Function(String);

class AiMenuWidget extends ConsumerStatefulWidget {
  const AiMenuWidget({super.key, this.onSubmit});
  final OnSubmit? onSubmit;

  @override
  ConsumerState<AiMenuWidget> createState() => _AiMenuWidgetState();
}

class _AiMenuWidgetState extends ConsumerState<AiMenuWidget> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController resController = TextEditingController();
  // late Stream<String> aiHelperStream = aiHelperMessageStream();

  @override
  void initState() {
    super.initState();
    // aiHelperStream.listen((v) {
    //   resController.text += v;
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    resController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 400,
        height: 500,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Navigator(
          initialRoute: "/",
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case "config":
                builder = (context) => const StyleConfigWidget();
                break;
              default:
                builder = (ctx) => _buildContent(ctx);
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Input your prompt'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: SizedBox(
                height: 35,
                child: TextField(
                  controller: controller,
                  decoration: AppStyle.inputDecoration,
                ),
              )),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  if (controller.text == "") {
                    return;
                  }
                  final state = ref.read(aiGenerateConfigNotifierProvider);
                  resController.text = "";
                  _aiQuickRequest(
                      s: controller.text,
                      tone: state.tone,
                      lang: state.lang,
                      length: state.length,
                      extra: state.extras);
                },
                child: const Icon(
                  Icons.send,
                  size: 25,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
                    return const StyleConfigWidget();
                  }));
                },
                child: const Icon(
                  Icons.settings,
                  size: 25,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text('Here is the result'),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey, width: 0.2)),
            child: TextField(
              controller: resController,
              enabled: true,
              maxLines: 12,
              decoration: AppStyle.inputDecoration,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  if (controller.text == "") {
                    return;
                  }
                  final state = ref.read(aiGenerateConfigNotifierProvider);
                  resController.text = "";
                  _aiQuickRequest(
                      s: controller.text,
                      tone: state.tone,
                      lang: state.lang,
                      length: state.length,
                      extra: state.extras);
                },
                child: const Tooltip(
                  message: "Re-generate",
                  child: Icon(Bootstrap.reply),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  if (widget.onSubmit != null) {
                    widget.onSubmit!(resController.text);
                  }
                },
                child: const Tooltip(
                  message: "Apply",
                  child: Icon(Bootstrap.check),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  final AiClient client = AiClient();

  _aiQuickRequest({
    required String s,
    required String tone,
    required String lang,
    required String length,
    required List<String> extra,
  }) {
    final List<String> requirements = List.from(extra);
    if (lang != "中文") {
      requirements.add("请使用$lang回答");
    }
    switch (length) {
      case "中等的":
        requirements.add("结果在500~1000字");
        break;
      case "长文":
        requirements.add("结果在1000~1500字");
        break;
      default:
        requirements.add("结果在500字以内");
    }
    if (tone != "正常的") {
      requirements.add("请使用$tone口吻回答");
    }
    String prompt = "$s。要求如下：\n{$requirements.join('\n')}";
    final Stream<ChatResult> stream =
        client.stream([MessageUtil.createHumanMessage(prompt)]);

    stream.listen((v) {
      resController.text += v.outputAsString;
    });
  }
}

class StyleConfigWidget extends ConsumerStatefulWidget {
  const StyleConfigWidget({super.key});

  @override
  ConsumerState<StyleConfigWidget> createState() => _StyleConfigWidgetState();
}

class _StyleConfigWidgetState extends ConsumerState<StyleConfigWidget> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiGenerateConfigNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      width: 400,
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "通用配置",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StyleDropdownButton(
                options: ["正常的", "严肃的"],
                label: '语气',
              ),
              StyleDropdownButton(
                options: ["短文", "中等的", "长文"],
                label: '字数',
              ),
              StyleDropdownButton(
                options: ["中文", "English"],
                label: '语言',
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "特殊配置",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          ...state.extras.map((v) => Container(
                height: 30,
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      v,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    )),
                    InkWell(
                      onTap: () {
                        ref
                            .read(aiGenerateConfigNotifierProvider.notifier)
                            .removeExtra(v);
                      },
                      child: const Icon(
                        Icons.delete,
                        size: 20,
                      ),
                    )
                  ],
                ),
              )),
          AddTagButton(
            onSave: (s) {
              if (s == "") {
                return;
              }
              ref.read(aiGenerateConfigNotifierProvider.notifier).addExtra(s);
            },
          ),
          const Spacer(),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("确定并返回"))
            ],
          )
        ],
      ),
    );
  }
}
