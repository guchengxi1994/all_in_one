import 'dart:io';

import 'package:all_in_one/app/common.dart';
import 'package:all_in_one/software_watcher/software_watcher_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    child: MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        fontFamily: "NotoSns",
        useMaterial3: true,
        tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
      ),
      debugShowCheckedModeBanner: false,
      home: const _Lauout(),
    ),
  ));
}

class _Lauout extends StatefulWidget {
  const _Lauout();

  @override
  State<_Lauout> createState() => __LauoutState();
}

class __LauoutState extends State<_Lauout> {
  Future<void> initSystemTray() async {
    String path = Platform.isWindows ? 'assets/icon.ico' : 'assets/icon.png';

    final AppWindow appWindow = AppWindow();
    final SystemTray systemTray = SystemTray();

    // We first init the systray menu
    await systemTray.initSystemTray(
      title: "system tray",
      iconPath: path,
    );

    // create context menu
    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
      MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
      MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
    ]);

    // set context menu
    await systemTray.setContextMenu(menu);

    // handle system tray event
    systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: WindowCaption(
          brightness: Brightness.light,
        ),
      ),
      body: SoftwareWatcherScreen(),
    );
  }
}
