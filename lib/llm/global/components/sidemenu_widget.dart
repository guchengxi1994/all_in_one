import 'package:all_in_one/llm/global/models/sidemenu_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SidemenuButton extends SidemenuItem {
  final IconData? icon;
  SidemenuButton({required this.icon, super.title, super.onTap});

  @override
  Widget toWidget({BuildContext? context}) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        showDuration: const Duration(milliseconds: 300),
        message: title,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: AutoSizeText(
                  title ?? "Click me",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SidemenuDivider extends SidemenuItem {
  @override
  Widget toWidget({BuildContext? context}) {
    return const Divider();
  }
}

class SidemenuLabel extends SidemenuItem {
  SidemenuLabel({super.title});

  @override
  Widget toWidget({BuildContext? context}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AutoSizeText(
        title ?? "Click me",
        maxLines: 1,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
