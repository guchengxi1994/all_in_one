import 'package:all_in_one/software_monitor/notifier/software_catalog_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'new_catalog_dialog.dart';
import 'software_catalog_list_item.dart';

class SoftwareCatalogList extends ConsumerWidget {
  const SoftwareCatalogList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(softwareCatalogProvider);
    return Container(
      width: 200,
      decoration: BoxDecoration(color: Colors.grey[200]!),
      child: notifier.when(
        data: (data) => Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              padding: const EdgeInsets.only(left: 5, right: 5),
              itemCount: data.catalogs.length,
              itemBuilder: (context, index) => SoftwareCatalogListItem(
                item: data.catalogs[index],
              ),
            )),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    final (String, String?)? r = await showGeneralDialog(
                        barrierLabel: "NewCatalogDialog",
                        barrierDismissible: true,
                        barrierColor: Colors.transparent,
                        context: context,
                        pageBuilder: (c, _, __) {
                          return const Center(
                            child: NewCatalogDialog(),
                          );
                        });

                    if (r != null) {
                      ref
                          .read(softwareCatalogProvider.notifier)
                          .addNewCatalog(r.$1, r.$2);
                    }
                  },
                  child: const Text("Add Catalog")),
            )
          ],
        ),
        error: (Object error, StackTrace stackTrace) {
          return Center(
            child: Text(stackTrace.toString()),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
