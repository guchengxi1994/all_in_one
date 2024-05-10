import 'dart:io';

import 'package:all_in_one/app/common.dart';
import 'package:all_in_one/layout/layout.dart';
import 'package:all_in_one/schedule/cron_listener.dart';
import 'package:all_in_one/software_monitor/notifier/monitor_item_notifier.dart';
import 'package:all_in_one/common/logger.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:all_in_one/src/rust/api/software_monitor_api.dart' as smapi;
import 'package:all_in_one/src/rust/api/sub_window_api.dart' as sw;
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

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
    child: _Wrapper(
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppFlowyEditorLocalizations.delegate,
        ],
        scrollBehavior: AppScrollBehavior(),
        supportedLocales: AppFlowyEditorLocalizations.delegate.supportedLocales,
        theme: ThemeData(
          colorSchemeSeed: AppStyle.appColor,
          fontFamily: "NotoSns",
          useMaterial3: true,
          tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
        ),
        debugShowCheckedModeBanner: false,
        // initialRoute: Routers.workboardScreen,
        home: const Layout(),
      ),
    ),
  ));
}

class _Wrapper extends ConsumerStatefulWidget {
  const _Wrapper({required this.child});
  final Widget child;

  @override
  ConsumerState<_Wrapper> createState() => __WrapperState();
}

class __WrapperState extends ConsumerState<_Wrapper> {
  initStream() {
    scheduleStream.listen((event) {
      logger.info("events $event");
      if (event.isNotEmpty) {
        sw.showTodos(data: []);
      }
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
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: WindowCaption(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset("assets/icon.png"),
                  ),
                ],
              ),
            ),
          ),
          body: widget.child,
        ));
  }
}
