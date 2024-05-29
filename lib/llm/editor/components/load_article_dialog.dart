import 'package:all_in_one/llm/editor/components/article_item.dart';
import 'package:all_in_one/llm/editor/notifiers/article_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadArticleDialog extends ConsumerStatefulWidget {
  const LoadArticleDialog({super.key});

  @override
  ConsumerState<LoadArticleDialog> createState() => _LoadArticleDialogState();
}

class _LoadArticleDialogState extends ConsumerState<LoadArticleDialog> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(articleProvider);

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
                        Expanded(
                          flex: 1,
                          child: Text("name"),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("create at"),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (c, i) {
                      return ArticleItem(
                        article: v[i],
                        onArticleSelected: (p0) {
                          Navigator.of(context).pop(p0);
                        },
                      );
                    },
                    itemCount: v.length,
                  )),
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
