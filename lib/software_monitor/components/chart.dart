import 'package:all_in_one/software_monitor/notifier/monitor_item_notifier.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoftwareChart extends ConsumerStatefulWidget {
  const SoftwareChart({super.key, required this.softwareId});
  final int softwareId;

  @override
  ConsumerState<SoftwareChart> createState() => _SoftwareChartState();
}

class _SoftwareChartState extends ConsumerState<SoftwareChart> {
  late int todayCount = 0;
  late List<int> lastSevenDays = [];
  late List<int> todayPerHour = [];

  late List<OrdinalData> lastSevenDaysList = [];
  late List<OrdinalData> today24HourList = [];

  // ignore: prefer_typing_uninitialized_variables
  var future;

  @override
  void initState() {
    super.initState();
    future = getInfo();
  }

  getInfo() async {
    final software =
        await ref.read(monitorItemProvider.notifier).getById(widget.softwareId);
    if (software != null) {
      todayCount = software.today();
      lastSevenDays = software.sevenDays();
      todayPerHour = software.last24Hours();
      lastSevenDaysList = lastSevenDays
          .mapIndexed((index, element) =>
              OrdinalData(domain: index.toString(), measure: element))
          .toList();
      today24HourList = todayPerHour
          .mapIndexed((index, element) => OrdinalData(
              domain: index < 12 ? "${index}am" : "${index}pm",
              measure: element))
          .toList();
    }
  }

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
        width: 500,
        height: 300,
        child: FutureBuilder(
            future: future,
            builder: (c, s) {
              if (s.connectionState == ConnectionState.done) {
                return DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      ButtonsTabBar(
                        physics: const NeverScrollableScrollPhysics(),
                        radius: 12,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        borderWidth: 2,
                        borderColor: Colors.transparent,
                        center: false,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        unselectedLabelStyle:
                            const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.white),
                        height: 56,
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.today),
                            text: "today",
                          ),
                          Tab(
                            icon: Icon(Icons.view_week),
                            text: "this week",
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: DChartBarO(
                                allowSliding: true,
                                groupList: [
                                  OrdinalGroup(
                                    id: '1',
                                    data: today24HourList,
                                  )
                                ],
                                domainAxis: DomainAxis(
                                  ordinalViewport: OrdinalViewport('1', 8),
                                ),
                              ),
                            ),
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: DChartBarO(
                                groupList: [
                                  OrdinalGroup(
                                    id: '2',
                                    data: lastSevenDaysList,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
