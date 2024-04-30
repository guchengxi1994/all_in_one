import 'package:all_in_one/tool_entry/routers/routers.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:all_in_one/tool_entry/components/buttons.dart';
import 'package:all_in_one/workboard/notifiers/tool_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tools extends ConsumerWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(toolProvider);
    return notifier.when(
        data: (data) {
          return Container(
            padding: const EdgeInsets.all(10),
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      const Text(
                        "Tools",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          ref
                              .read(toolEntryRoutersProvider.notifier)
                              .changeRouter(Routers.entryScreen);
                        },
                        child: Transform.rotate(
                          angle: 3.14 / 4,
                          child: const Icon(Icons.navigation,
                              color: AppStyle.appCheckColor),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    children: data.map((e) => getByName(e.$2, ref)).toList(),
                  ),
                ),
              ],
            ),
          );
        },
        error: (o, e) {
          return Text(o.toString());
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
