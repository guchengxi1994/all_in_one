import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/software_watcher/notifier/software_catalog_notifier.dart';
import 'package:all_in_one/software_watcher/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
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
      child: widget.item.id == 1
          ? _buildChild(notifier)
          : ContextMenuRegion(
              menuType: MenuType.desktop,
              onItemSelected: (value) {
                if (value == null) {
                  return;
                }
                ref
                    .read(softwareCatalogProvider.notifier)
                    .changeIcon(widget.item.id, value);
              },
              contextMenu: ContextMenu(entries: [
                MenuItem.submenu(
                    label: "Change Icon",
                    items: CatalogIcons.icons
                        .map((key, value) => MapEntry(
                            key,
                            MenuItem(
                                value: key,
                                icon: Icon(
                                  value,
                                  color: Colors.black,
                                ),
                                label: "$key recommend")))
                        .values
                        .toList()
                      ..add(const MenuItem(value: "None", label: "None")))
              ]),
              child: _buildChild(notifier)),
    );
  }

  Widget _buildChild(AsyncValue notifier) {
    return DragTarget<int>(
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
                  if (CatalogIcons.getByName(widget.item.catalogIconName) !=
                      null)
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: CatalogIcons.getByName(widget.item.catalogIconName,
                          color: Colors.black),
                    ),
                  Text(
                    widget.item.name,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
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
    );
  }
}
