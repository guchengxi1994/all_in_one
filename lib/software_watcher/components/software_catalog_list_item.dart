import 'package:all_in_one/isar/software.dart';
import 'package:all_in_one/software_watcher/notifier/software_catalog_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoftwareCatalogListItem extends ConsumerWidget {
  const SoftwareCatalogListItem({super.key, required this.item});
  final SoftwareCatalog item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          height: 50,
          width: 200,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(item.name),
          ),
        ),
      ),
    );
  }
}
