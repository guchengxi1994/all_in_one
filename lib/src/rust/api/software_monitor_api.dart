// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.31.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../software_monitor/software.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<List<Software>> getWindowsInstalledSoftwares({dynamic hint}) =>
    RustLib.instance.api.getWindowsInstalledSoftwares(hint: hint);

Stream<Int64List> softwareWatchingMessageStream({dynamic hint}) =>
    RustLib.instance.api.softwareWatchingMessageStream(hint: hint);

Stream<(Int64List, String)> softwareWatchingWithForegroundMessageStream(
        {dynamic hint}) =>
    RustLib.instance.api
        .softwareWatchingWithForegroundMessageStream(hint: hint);

Future<void> addToWatchingList(
        {required int id, required String name, dynamic hint}) =>
    RustLib.instance.api.addToWatchingList(id: id, name: name, hint: hint);

Future<void> removeFromWatchingList({required int id, dynamic hint}) =>
    RustLib.instance.api.removeFromWatchingList(id: id, hint: hint);

Future<void> initMonitor({required List<(int, String)> items, dynamic hint}) =>
    RustLib.instance.api.initMonitor(items: items, hint: hint);