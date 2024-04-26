import 'package:all_in_one/routers/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/buttons.dart';

class EntryScreen extends ConsumerWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            if (ref.watch(toolEntryRoutersProvider) != "/")
              SizedBox(
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        ref.read(toolEntryRoutersProvider.notifier).toMain();
                      },
                      child: const Icon(Icons.chevron_left),
                    )
                  ],
                ),
              ),
            Expanded(
                child: Navigator(
              key: Routers.navigatorKey,
              initialRoute: "/",
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case "/":
                    return _buildChild(ref);

                  case "/softwareMonitorScreen":
                    return _pageBuilder(
                        settings, "/softwareMonitorScreen", context);
                  case "/scheduleScreen":
                    return _pageBuilder(settings, "/scheduleScreen", context);
                  case "/timeConverterScreen":
                    return _pageBuilder(
                        settings, "/timeConverterScreen", context);
                  case "/systemMonitorScreen":
                    return _pageBuilder(
                        settings, "/systemMonitorScreen", context);
                  case "/netstatManagerScreen":
                    return _pageBuilder(
                        settings, "/netstatManagerScreen", context);
                  default:
                    return _buildChild(ref);
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  PageRouteBuilder _pageBuilder(
      RouteSettings settings, String pageRoute, BuildContext context) {
    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => Routers.routers[pageRoute]!.call(context),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        });
  }

  PageRouteBuilder _buildChild(WidgetRef ref) {
    return PageRouteBuilder(
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        },
        pageBuilder: (_, __, ___) => Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 15,
                spacing: 15,
                children: [
                  monitorButton(ref),
                  scheduleButton(ref),
                  converterButton(ref),
                  systemMonitorButton(ref),
                  netstatManagerButton(ref)
                ],
              ),
            ));
  }
}
