import 'package:all_in_one/system_monitor/components/process_item.dart';
import 'package:all_in_one/system_monitor/notifiers/process_notifier.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Processes extends ConsumerStatefulWidget {
  const Processes({super.key});

  @override
  ConsumerState<Processes> createState() => _ProcessesState();
}

class _ProcessesState extends ConsumerState<Processes>
    with TickerProviderStateMixin {
  late final TabController controller;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(processProvider);

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: TabBar(controller: controller, tabs: const [
            Text(
              "cpu",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "memory",
              style: TextStyle(color: Colors.white),
            )
          ]),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: TabBarView(controller: controller, children: [
            ListView.builder(
              itemBuilder: (c, i) {
                final value = state.cpus[i].cpu / state.cpus.first.cpu;

                return ProcessItem(
                    name: state.cpus[i].name,
                    rate: value,
                    value: "${state.cpus[i].cpu.ceilToDouble()}%");
              },
              itemCount: state.cpus.length,
            ),
            ListView.builder(
              itemBuilder: (c, i) {
                final value =
                    state.memories[i].memory / state.memories.first.memory;
                return ProcessItem(
                    name: state.memories[i].name,
                    rate: value,
                    value: filesize(state.memories[i].memory));
              },
              itemCount: state.memories.length,
            )
          ]),
        ))
      ],
    );
  }
}
