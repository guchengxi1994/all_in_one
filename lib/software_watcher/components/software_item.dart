import 'dart:io';

import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/software_watcher/notifier/watcher_item_notifier.dart';
import 'package:all_in_one/software_watcher/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import 'simple_textfield_dialog.dart';

class SoftwareItem extends ConsumerStatefulWidget {
  const SoftwareItem({super.key, required this.item});
  final Software item;

  @override
  ConsumerState<SoftwareItem> createState() => _SoftwareItemState();
}

class _SoftwareItemState extends ConsumerState<SoftwareItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();
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
      child: ContextMenuRegion(
          onItemSelected: (value) async {
            if (value == "Watch") {
              setState(() {
                widget.item.isWatching = true;
              });
            }
            if (value == "Unwatch") {
              setState(() {
                widget.item.isWatching = false;
              });
            }
            if (value == "Set short name") {
              final String? r = await showGeneralDialog(
                  barrierDismissible: true,
                  barrierLabel: "SimpleTextFieldDialog-2",
                  context: context,
                  pageBuilder: (c, _, __) {
                    return Center(
                        child: SimpleTextFieldDialog(
                      initial: widget.item.shortName ?? "",
                    ));
                  });
              if (r != null) {
                setState(() {
                  widget.item.shortName = r;
                });
              }
            }
            if (value == "Set progress name") {
              final String? r = await showGeneralDialog(
                  barrierDismissible: true,
                  barrierLabel: "SimpleTextFieldDialog-1",
                  // ignore: use_build_context_synchronously
                  context: context,
                  pageBuilder: (c, _, __) {
                    return Center(
                        child: SimpleTextFieldDialog(
                      initial: widget.item.associatedSoftwareName ?? "",
                    ));
                  });
              if (r != null) {
                widget.item.associatedSoftwareName = r.toLowerCase();
              }
            }

            ref.read(watcherItemProvider.notifier).saveItem(widget.item);
          },
          menuType: MenuType.desktop,
          contextMenu: ContextMenu(entries: [
            const MenuItem(
                label: "Watch", value: "Watch", icon: Icon(AntDesign.eye_fill)),
            const MenuItem(
                label: "Unwatch",
                value: "Unwatch",
                icon: Icon(AntDesign.eye_invisible_fill)),
            const MenuItem(
                label: "Set short name",
                value: "Set short name",
                icon: Icon(Icons.short_text)),
            const MenuItem(
                label: "Set progress name",
                value: "Set progress name",
                icon: Icon(AntDesign.profile_fill)),
          ]),
          child: Tooltip(
            waitDuration: const Duration(milliseconds: 200),
            message: widget.item.name,
            child: Draggable<int>(
              data: widget.item.id,
              feedback: child,
              child: child,
            ),
          )),
    );
  }

  Widget _buildChild() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isHovering
                  ? Colors.lightBlue.withAlpha(100)
                  : Colors.transparent,
              border: Border.all(color: Colors.grey[200]!)),
          child: Column(
            children: [
              widget.item.iconPath!.endsWith(".ico")
                  ? _image(
                      Image.file(
                        File(widget.item.iconPath!),
                        fit: BoxFit.fill,
                      ),
                    )
                  : widget.item.icon != null
                      ? _image(
                          Image.memory(
                            widget.item.convertIconToByteList()!,
                            fit: BoxFit.fill,
                          ),
                        )
                      : _image(
                          const Icon(Icons.apps),
                        ),
              Text(
                widget.item.shortName ?? widget.item.name,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: CatalogIcons.getByName(
                  widget.item.catalog.value?.catalogIconName) ??
              const SizedBox(),
        ),
        if (widget.item.isWatching)
          Positioned(
            bottom: 5,
            right: 5,
            child: Icon(
              AntDesign.eye_fill,
              size: 20,
              color: Colors.red.withOpacity(0.5),
            ),
          )
      ],
    );
  }

  Widget _image(Widget c) {
    return SizedBox(
      width: 48,
      height: 48,
      child: c,
    );
  }
}
