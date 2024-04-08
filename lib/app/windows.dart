import 'dart:io';

import 'package:all_in_one/app/common.dart';
import 'package:all_in_one/entry/routers.dart';
import 'package:all_in_one/software_watcher/notifier/watcher_item_notifier.dart';
import 'package:all_in_one/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:all_in_one/src/rust/api/software_watcher_api.dart' as swapi;
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

  runApp(ProviderScope(
    observers: kDebugMode ? [SimpleObserver()] : [],
    child: _Lauout(
      child: MaterialApp(
        scrollBehavior: AppScrollBehavior(),
        theme: ThemeData(
          fontFamily: "NotoSns",
          useMaterial3: true,
          tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
        ),
        debugShowCheckedModeBanner: false,
        routes: Routers.routers,
        navigatorKey: Routers.navigatorKey,
        initialRoute: Routers.entryScreen,
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
    stream.listen((event) {
      // print(event);
      logger.info(event);
      if (event is Int64List) {
        ref
            .read(watcherItemProvider.notifier)
            .updateRunning(event.map((element) => element.toInt()).toList());
      } else {
        ref.read(watcherItemProvider.notifier).updateRunning(
            (event as (Int64List, String))
                .$1
                .map((element) => element.toInt())
                .toList(),
            foreground: event.$2);
      }
    });
  }

  final stream = Platform.isWindows
      ? swapi.softwareWatchingWithForegroundMessageStream()
      : swapi.softwareWatchingMessageStream();

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
            preferredSize: const Size.fromHeight(30),
            child: WindowCaption(
              brightness: Brightness.light,
              title: Row(
                children: [
                  if (ref.watch(routersProvider) != Routers.entryScreen)
                    InkWell(
                      onTap: () {
                        ref.read(routersProvider.notifier).toMain();
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
