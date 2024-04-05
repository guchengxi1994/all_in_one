import 'dart:io';

import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/software_watcher/styles/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      child: Tooltip(
        waitDuration: const Duration(milliseconds: 200),
        message: widget.item.name,
        child: Draggable<int>(
          data: widget.item.id,
          feedback: child,
          child: child,
        ),
      ),
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
                widget.item.name..replaceAll(" ", ""),
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
