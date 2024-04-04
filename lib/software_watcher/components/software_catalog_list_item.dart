import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/software_watcher/notifier/software_catalog_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoftwareCatalogListItem extends ConsumerStatefulWidget {
  const SoftwareCatalogListItem({super.key, required this.item});
  final SoftwareCatalog item;

  @override
  ConsumerState<SoftwareCatalogListItem> createState() =>
      _SoftwareCatalogListItemState();
}

class _SoftwareCatalogListItemState
    extends ConsumerState<SoftwareCatalogListItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(softwareCatalogProvider);
    return MouseRegion(
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
      child: DragTarget<int>(
        builder: (c, ca, re) {
          return InkWell(
            onTap: () {
              ref
                  .read(softwareCatalogProvider.notifier)
                  .changeCurrent(widget.item.id);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: (notifier.value?.current == widget.item.id) || isHovering
                    ? Colors.lightBlue.withAlpha(100)
                    : Colors.transparent,
              ),
              height: 50,
              width: 200,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(widget.item.name),
                    const Spacer(),
                    if (widget.item.deletable)
                      InkWell(
                        onTap: () {
                          ref
                              .read(softwareCatalogProvider.notifier)
                              .deleteCatalog(widget.item.id);
                        },
                        child: const Icon(Icons.delete),
                      )
                  ],
                ),
              ),
            ),
          );
        },
        onAcceptWithDetails: (data) {
          // print(data.data);
          ref
              .read(softwareCatalogProvider.notifier)
              .markItemCatalog(data.data, widget.item);
        },
      ),
    );
  }
}
