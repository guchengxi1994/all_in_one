import 'package:all_in_one/layout/notifiers/page_notifier.dart';
import 'package:all_in_one/layout/notifiers/sidebar_notifier.dart';
import 'package:all_in_one/layout/styles.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SidebarItem {
  final String icon;
  final String inActiveIcon;
  final String name;
  final int index;

  SidebarItem(
      {required this.icon,
      required this.index,
      required this.name,
      required this.inActiveIcon});
}

class SidebarItemWidget extends ConsumerWidget {
  const SidebarItemWidget({super.key, required this.item});
  final SidebarItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(sidebarProvider);
    final isSelected = ref.watch(pageProvider) == item.index;
    return GestureDetector(
      onTap: () {
        ref.read(pageProvider.notifier).changePage(item.index);
      },
      child: Container(
        // alignment: Alignment.centerLeft,
        width: isExpanded
            ? LayoutStyle.sidebarExpand
            : LayoutStyle.sidebarCollapse,
        padding: const EdgeInsets.all(10),
        child: isExpanded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      isSelected ? item.icon : item.inActiveIcon,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AutoSizeText(
                    item.name,
                    style: TextStyle(
                        color: isSelected ? Colors.black : AppStyle.grey),
                  )
                ],
              )
            : SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  isSelected ? item.icon : item.inActiveIcon,
                ),
              ),
      ),
    );
  }
}
