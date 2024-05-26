// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.35.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../llm/app_flowy_model.dart';
import '../llm/plugins/chat_db.dart';
import '../llm/plugins/chat_db/mysql.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<List<List<TableInfo>>> getMysqlTableInfo(
        {required DatabaseInfo s, dynamic hint}) =>
    RustLib.instance.api
        .crateApiLlmPluginApiGetMysqlTableInfo(s: s, hint: hint);

Future<Map<String, String>?> eval(
        {required String sqlStr,
        required DatabaseInfo db,
        required List<(String, CellType)> keys,
        dynamic hint}) =>
    RustLib.instance.api.crateApiLlmPluginApiEval(
        sqlStr: sqlStr, db: db, keys: keys, hint: hint);

Future<List<(String, AttributeType, String?)>> templateToPrompts(
        {required String template, dynamic hint}) =>
    RustLib.instance.api
        .crateApiLlmPluginApiTemplateToPrompts(template: template, hint: hint);
