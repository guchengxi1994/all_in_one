import 'package:all_in_one/isar/database.dart';
import 'package:all_in_one/isar/schedule.dart';
import 'package:all_in_one/routers/routers.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class TodoList extends ConsumerStatefulWidget {
  const TodoList({super.key});

  @override
  ConsumerState<TodoList> createState() => _TodoListState();
}

class _TodoListState extends ConsumerState<TodoList> {
  final IsarDatabase database = IsarDatabase();

  List<ScheduleItem> items = [];

  @override
  void initState() {
    super.initState();
    future = fetchItems();
  }

  // ignore: prefer_typing_uninitialized_variables
  var future;

  fetchItems() async {
    final now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime nextDay = today.add(const Duration(days: 1));
    items = await database.isar!.scheduleItems
        .filter()
        .fromInMillBetween(
            today.millisecondsSinceEpoch, nextDay.millisecondsSinceEpoch)
        .findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                const Text(
                  "Todolist",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    ref
                        .read(routersProvider.notifier)
                        .changeRouter(Routers.scheduleScreen);
                  },
                  child: Transform.rotate(
                    angle: 3.14 / 4,
                    child: const Icon(
                      Icons.navigation,
                      color: AppStyle.appCheckColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
                future: future,
                builder: (c, s) {
                  if (s.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemBuilder: (c, i) {
                        return Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          height: 30,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppStyle.appButtonColor),
                              borderRadius: BorderRadius.circular(20)),
                          child: AutoSizeText(
                            items[i].eventName,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      itemCount: items.length,
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          )
        ],
      ),
    );
  }
}
