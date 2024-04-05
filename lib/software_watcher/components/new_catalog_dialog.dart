// ignore_for_file: avoid_init_to_null

import 'package:all_in_one/software_watcher/styles/icons.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';

class NewCatalogDialog extends StatefulWidget {
  const NewCatalogDialog({super.key});

  @override
  State<NewCatalogDialog> createState() => _NewCatalogDialogState();
}

class _NewCatalogDialogState extends State<NewCatalogDialog> {
  final TextEditingController controller = TextEditingController();

  bool expansion = false;
  String? selectedIcon = null;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        width: 400,
        height: expansion ? 250 : 180,
        child: Column(
          children: [
            TextField(
              decoration: AppStyle.inputDecoration,
              controller: controller,
            ),
            // const SizedBox(
            //   height: 30,
            // ),
            ExpansionTile(
              shape: const Border(
                top: BorderSide.none,
                bottom: BorderSide.none,
              ),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              onExpansionChanged: (value) {
                setState(() {
                  expansion = value;
                });
              },
              title: const Text("(Optional) Select an icon"),
              children: [
                SizedBox(
                  height: 80,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: CatalogIcons.icons
                          .map((key, value) => MapEntry(
                              key,
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIcon = key;
                                  });
                                },
                                child: Icon(
                                  value,
                                  color: selectedIcon == key
                                      ? AppStyle.appColor
                                      : Colors.black,
                                ),
                              )))
                          .values
                          .toList() as List<Widget>,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: Text("Cancel")),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop((controller.text, selectedIcon));
                    },
                    child: Text("Ok")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
