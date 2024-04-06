import 'package:all_in_one/entry/entry_screen.dart' deferred as entry;
import 'package:all_in_one/entry/future_builder.dart';
import 'package:all_in_one/software_watcher/software_watcher_screen.dart'
    deferred as software;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Routers {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static String entryScreen = "/entryScreen";
  static String softwareWatcherScreen = "/softwareWatcherScreen";

  static Map<String, WidgetBuilder> routers = {
    entryScreen: (context) => FutureLoaderWidget(
        builder: (context) => entry.EntryScreen(),
        loadWidgetFuture: entry.loadLibrary()),
    softwareWatcherScreen: (context) => FutureLoaderWidget(
        builder: (context) => software.SoftwareWatcherScreen(),
        loadWidgetFuture: software.loadLibrary()),
  };
}

class RoutersNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() {
    return Routers.entryScreen;
  }

  changeRouter(String s) {
    if (Routers.routers.keys.contains(s)) {
      state = s;
      Routers.navigatorKey.currentState!.pushNamed(s);
    }
  }

  toMain() {
    state = Routers.entryScreen;
    Routers.navigatorKey.currentState!
        .pushNamedAndRemoveUntil(Routers.entryScreen, (route) => false);
  }
}

final routersProvider = AutoDisposeNotifierProvider<RoutersNotifier, String>(
    () => RoutersNotifier());
