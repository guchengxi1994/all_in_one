import 'dart:io';

import 'package:all_in_one/app/common.dart';
import 'package:all_in_one/routers/routers.dart';
import 'package:all_in_one/schedule/cron_listener.dart';
import 'package:all_in_one/software_monitor/notifier/monitor_item_notifier.dart';
import 'package:all_in_one/common/logger.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:all_in_one/src/rust/api/software_monitor_api.dart' as smapi;
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

void runWindowsAPP() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  windowManager.waitUntilReadyToShow(null, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setHasShadow(true);
  });
  windowManager.setBackgroundColor(Colors.transparent);

  CronListener.start();

  runApp(ProviderScope(
    // observers: kDebugMode ? [SimpleObserver()] : [],
    child: _Lauout(
      child: MaterialApp(
        scrollBehavior: AppScrollBehavior(),
        theme: ThemeData(
          colorSchemeSeed: AppStyle.appColor,
          fontFamily: "NotoSns",
          useMaterial3: true,
          tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
        ),
        debugShowCheckedModeBanner: false,
        routes: Routers.routers,
        navigatorKey: Routers.navigatorKey,
        initialRoute: Routers.workboardScreen,
      ),
    ),
  ));
}

class _Lauout extends ConsumerStatefulWidget {
  const _Lauout({required this.child});
  final Widget child;

  @override
  ConsumerState<_Lauout> createState() => __LauoutState();
}

class __LauoutState extends ConsumerState<_Lauout> {
  initStream() {
    scheduleStream.listen((event) {
      logger.info("events $event");
    });

    stream.listen((event) {
      // print(event);
      logger.info(event);
      if (event is Int64List) {
        ref
            .read(monitorItemProvider.notifier)
            .updateRunning(event.map((element) => element.toInt()).toList());
      } else {
        ref.read(monitorItemProvider.notifier).updateRunning(
            (event as (Int64List, String))
                .$1
                .map((element) => element.toInt())
                .toList(),
            foreground: event.$2);
      }
    });
  }

  final scheduleStream = CronListener.controller.stream;

  final stream = Platform.isWindows
      ? smapi.softwareWatchingWithForegroundMessageStream()
      : smapi.softwareWatchingMessageStream();

  @override
  void initState() {
    super.initState();
    initStream();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: AppStyle.appColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: WindowCaption(
              backgroundColor: AppStyle.appColor,
              brightness: Brightness.dark,
              title: Row(
                children: [
                  if (ref.watch(routersProvider) != Routers.workboardScreen)
                    InkWell(
                      onTap: () {
                        if (ref.watch(routersProvider) == Routers.entryScreen) {
                          ref.read(routersProvider.notifier).toMain();
                        } else {
                          ref.read(routersProvider.notifier).toEntries();
                        }
                      },
                      child: const Icon(Bootstrap.arrow_left),
                    )
                ],
              ),
            ),
          ),
          body: widget.child,
        ));
  }
}
