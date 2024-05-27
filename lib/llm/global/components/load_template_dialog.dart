import 'package:all_in_one/llm/global/components/template_item.dart';
import 'package:all_in_one/llm/global/notifiers/template_select_notifier.dart';
import 'package:all_in_one/llm/template_editor/notifiers/template_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadTemplateDialog extends ConsumerStatefulWidget {
  const LoadTemplateDialog({super.key});

  @override
  ConsumerState<LoadTemplateDialog> createState() => _LoadTemplateDialogState();
}

class _LoadTemplateDialogState extends ConsumerState<LoadTemplateDialog> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(templateNotifierProvider);

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: state.when(
            data: (v) {
              if (v.isEmpty) {
                return const Center(
                  child: Text("There is no template created."),
                );
              }

              return Column(
                children: [
                  const SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("name"),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text("content"),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (c, i) {
                      return TemplateItem(
                          template: v[i],
                          onTemplateSelected: (index) {
                            // print(index);
                            ref
                                .read(templateSelectProvider.notifier)
                                .changeState(index);
                          });
                    },
                    itemCount: v.length,
                  )),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        ElevatedButton(
                            onPressed: () {
                              if (ref.read(templateSelectProvider) == -1) {
                                return;
                              }
                              Navigator.of(context).pop(v
                                  .where((i) =>
                                      i.id == ref.read(templateSelectProvider))
                                  .first);
                            },
                            child: const Text("Apply"))
                      ],
                    ),
                  )
                ],
              );
            },
            error: (_, s) {
              return Center(
                child: Text(s.toString()),
              );
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      ),
    );
  }
}
