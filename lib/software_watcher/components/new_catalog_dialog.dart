import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';

class NewCatalogDialog extends StatelessWidget {
  NewCatalogDialog({super.key});
  final TextEditingController controller = TextEditingController();

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
        height: 150,
        child: Column(
          children: [
            TextField(
              decoration: AppStyle.inputDecoration,
              controller: controller,
            ),
            const SizedBox(
              height: 30,
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
                      Navigator.of(context).pop(controller.text);
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
