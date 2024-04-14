import 'package:all_in_one/routers/routers.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/clock.dart';

class WorkboardScreen extends ConsumerStatefulWidget {
  const WorkboardScreen({super.key});

  @override
  ConsumerState<WorkboardScreen> createState() => _WorkboardScreenState();
}

class _WorkboardScreenState extends ConsumerState<WorkboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.appColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: LayoutGrid(
          areas: """
area1 area1 area2 area2 time
area1 area1 area2 area2 todo
area1 area1 area2 area2 todo
area3 area3 area4 area4 todo
""",
          columnSizes: [auto, auto, auto, auto, 250.px],
          rowSizes: [
            120.px,
            auto,
            auto,
            auto,
          ],
          columnGap: 12,
          rowGap: 12,
          children: [
            _wrapper(InkWell(
              onTap: () {
                ref
                    .read(routersProvider.notifier)
                    .changeRouter(Routers.entryScreen);
              },
            )).inGridArea('area1'),
            _wrapper(null).inGridArea('area2'),
            _wrapper(const Clock()).inGridArea('time'),
            _wrapper(null).inGridArea('todo'),
            _wrapper(null).inGridArea('area3'),
            _wrapper(null).inGridArea('area4'),
          ],
        ),
      ),
    );
  }

  Widget _wrapper(Widget? child) {
    return Container(
      decoration: BoxDecoration(
          color: AppStyle.appColorLight,
          borderRadius: BorderRadius.circular(4)),
      child: child,
    );
  }
}
