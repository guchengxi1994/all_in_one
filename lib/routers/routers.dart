import 'package:all_in_one/tool_entry/entry_screen.dart' deferred as entry;
import 'package:all_in_one/tool_entry/notifiers/entry_notifier.dart';
import 'package:all_in_one/routers/future_builder.dart';
import 'package:all_in_one/schedule/schedule_screen.dart' deferred as schedule;
import 'package:all_in_one/software_monitor/software_monitor_screen.dart'
    deferred as software;
import 'package:all_in_one/time_converter/time_converter_screen.dart'
    deferred as tc;
import 'package:all_in_one/workboard/workboard_screen.dart' deferred as wb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Routers {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static String workboardScreen = "/workboardScreen";
  static String entryScreen = "/entryScreen";
  static String softwareMonitorScreen = "/softwareMonitorScreen";
  static String scheduleScreen = "/scheduleScreen";
  static String timeConverterScreen = "/timeConverterScreen";

  static Map<String, String> toolRouters = {
    softwareMonitorScreen: "monitor",
    scheduleScreen: "schedule",
    timeConverterScreen: "converter"
  };

  static Map<String, WidgetBuilder> routers = {
    workboardScreen: (context) => FutureLoaderWidget(
        builder: (context) => wb.WorkboardScreen(),
        loadWidgetFuture: wb.loadLibrary()),
    entryScreen: (context) => FutureLoaderWidget(
        builder: (context) => entry.EntryScreen(),
        loadWidgetFuture: entry.loadLibrary()),
    softwareMonitorScreen: (context) => FutureLoaderWidget(
        builder: (context) => software.SoftwareMonitorScreen(),
        loadWidgetFuture: software.loadLibrary()),
    scheduleScreen: (context) => FutureLoaderWidget(
        builder: (context) => schedule.ScheduleScreen(),
        loadWidgetFuture: schedule.loadLibrary()),
    timeConverterScreen: (context) => FutureLoaderWidget(
        builder: (context) => tc.TimeConverterScreen(),
        loadWidgetFuture: tc.loadLibrary()),
  };
}

class RoutersNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() {
    return Routers.workboardScreen;
  }

  changeRouter(String s) {
    if (Routers.routers.keys.contains(s)) {
      state = s;
      ref.read(entryProvider.notifier).newRecord(Routers.toolRouters[s], s);
      Routers.navigatorKey.currentState!.pushNamed(s);
    }
  }

  toMain() {
    state = Routers.workboardScreen;
    Routers.navigatorKey.currentState!
        .pushNamedAndRemoveUntil(Routers.workboardScreen, (route) => false);
  }

  toEntries() {
    state = Routers.entryScreen;
    Routers.navigatorKey.currentState!
        .pushNamedAndRemoveUntil(Routers.entryScreen, (route) => false);
  }
}

final routersProvider = AutoDisposeNotifierProvider<RoutersNotifier, String>(
    () => RoutersNotifier());
