import 'package:all_in_one/isar/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef OnArticleSelected = void Function(Article);

class ArticleItem extends ConsumerStatefulWidget {
  const ArticleItem(
      {super.key, required this.article, required this.onArticleSelected});
  final Article article;
  final OnArticleSelected onArticleSelected;

  @override
  ConsumerState<ArticleItem> createState() => _ArticleItemState();
}

class _ArticleItemState extends ConsumerState<ArticleItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onArticleSelected(widget.article);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              color: isHovering
                  ? const Color.fromARGB(255, 197, 195, 227).withAlpha(100)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  widget.article.title,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  DateTime.fromMillisecondsSinceEpoch(widget.article.createAt)
                      .toString()
                      .split(".")
                      .first,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
