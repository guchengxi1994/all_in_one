// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.31.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/llm_api.dart';
import 'api/llm_plugin_api.dart';
import 'api/process_port_mapper_api.dart';
import 'api/simple.dart';
import 'api/software_monitor_api.dart';
import 'api/sub_window_api.dart';
import 'api/system_monitor_api.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'frb_generated.dart';
import 'llm.dart';
import 'llm/app_flowy_model.dart';
import 'llm/plugins/chat_db.dart';
import 'llm/plugins/chat_db/mysql.dart';
import 'llm/template.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';
import 'software_monitor/software.dart';
import 'system_monitor.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_RustSimpleNotifyLibPinWindowItemPtr =>
          wire._rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItemPtr;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  RustSimpleNotifyLibPinWindowItem
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic raw);

  @protected
  Map<String, String> dco_decode_Map_String_String(dynamic raw);

  @protected
  RustSimpleNotifyLibPinWindowItem
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic raw);

  @protected
  RustStreamSink<Int64List> dco_decode_StreamSink_list_prim_i_64_strict_Sse(
      dynamic raw);

  @protected
  RustStreamSink<LLMMessage> dco_decode_StreamSink_llm_message_Sse(dynamic raw);

  @protected
  RustStreamSink<MonitorInfo> dco_decode_StreamSink_monitor_info_Sse(
      dynamic raw);

  @protected
  RustStreamSink<(Int64List, String)>
      dco_decode_StreamSink_record_list_prim_i_64_strict_string_Sse(
          dynamic raw);

  @protected
  RustStreamSink<TemplateResult> dco_decode_StreamSink_template_result_Sse(
      dynamic raw);

  @protected
  RustStreamSink<TemplateRunningStage>
      dco_decode_StreamSink_template_running_stage_Sse(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  Attributes dco_decode_attributes(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  Attributes dco_decode_box_autoadd_attributes(dynamic raw);

  @protected
  CpuInfo dco_decode_box_autoadd_cpu_info(dynamic raw);

  @protected
  DatabaseInfo dco_decode_box_autoadd_database_info(dynamic raw);

  @protected
  EnvParams dco_decode_box_autoadd_env_params(dynamic raw);

  @protected
  int dco_decode_box_autoadd_i_64(dynamic raw);

  @protected
  MemoryInfo dco_decode_box_autoadd_memory_info(dynamic raw);

  @protected
  Root dco_decode_box_autoadd_root(dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_32(dynamic raw);

  @protected
  CellType dco_decode_cell_type(dynamic raw);

  @protected
  Children dco_decode_children(dynamic raw);

  @protected
  CpuInfo dco_decode_cpu_info(dynamic raw);

  @protected
  Data dco_decode_data(dynamic raw);

  @protected
  DatabaseInfo dco_decode_database_info(dynamic raw);

  @protected
  Delum dco_decode_delum(dynamic raw);

  @protected
  Document dco_decode_document(dynamic raw);

  @protected
  EnvParams dco_decode_env_params(dynamic raw);

  @protected
  double dco_decode_f_32(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  int dco_decode_i_64(dynamic raw);

  @protected
  List<RustSimpleNotifyLibPinWindowItem>
      dco_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<Children> dco_decode_list_children(dynamic raw);

  @protected
  List<Delum> dco_decode_list_delum(dynamic raw);

  @protected
  List<List<TableInfo>> dco_decode_list_list_table_info(dynamic raw);

  @protected
  List<LLMMessage> dco_decode_list_llm_message(dynamic raw);

  @protected
  List<MountedInfo> dco_decode_list_mounted_info(dynamic raw);

  @protected
  Int64List dco_decode_list_prim_i_64_strict(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  List<ProcessPortMapper> dco_decode_list_process_port_mapper(dynamic raw);

  @protected
  List<(int, String)> dco_decode_list_record_i_64_string(dynamic raw);

  @protected
  List<(String, CellType)> dco_decode_list_record_string_cell_type(dynamic raw);

  @protected
  List<(String, String)> dco_decode_list_record_string_string(dynamic raw);

  @protected
  List<(String, int, int?)>
      dco_decode_list_record_string_u_32_opt_box_autoadd_u_32(dynamic raw);

  @protected
  List<Software> dco_decode_list_software(dynamic raw);

  @protected
  List<SoftwareCpu> dco_decode_list_software_cpu(dynamic raw);

  @protected
  List<SoftwareMemory> dco_decode_list_software_memory(dynamic raw);

  @protected
  List<TableInfo> dco_decode_list_table_info(dynamic raw);

  @protected
  LLMMessage dco_decode_llm_message(dynamic raw);

  @protected
  MemoryInfo dco_decode_memory_info(dynamic raw);

  @protected
  MonitorInfo dco_decode_monitor_info(dynamic raw);

  @protected
  MountedInfo dco_decode_mounted_info(dynamic raw);

  @protected
  Map<String, String>? dco_decode_opt_Map_String_String(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  Attributes? dco_decode_opt_box_autoadd_attributes(dynamic raw);

  @protected
  CpuInfo? dco_decode_opt_box_autoadd_cpu_info(dynamic raw);

  @protected
  EnvParams? dco_decode_opt_box_autoadd_env_params(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_i_64(dynamic raw);

  @protected
  MemoryInfo? dco_decode_opt_box_autoadd_memory_info(dynamic raw);

  @protected
  Root? dco_decode_opt_box_autoadd_root(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_32(dynamic raw);

  @protected
  List<LLMMessage>? dco_decode_opt_list_llm_message(dynamic raw);

  @protected
  List<MountedInfo>? dco_decode_opt_list_mounted_info(dynamic raw);

  @protected
  Uint8List? dco_decode_opt_list_prim_u_8_strict(dynamic raw);

  @protected
  List<SoftwareCpu>? dco_decode_opt_list_software_cpu(dynamic raw);

  @protected
  List<SoftwareMemory>? dco_decode_opt_list_software_memory(dynamic raw);

  @protected
  ProcessPortMapper dco_decode_process_port_mapper(dynamic raw);

  @protected
  (int, String) dco_decode_record_i_64_string(dynamic raw);

  @protected
  (Int64List, String) dco_decode_record_list_prim_i_64_strict_string(
      dynamic raw);

  @protected
  (String, CellType) dco_decode_record_string_cell_type(dynamic raw);

  @protected
  (String, String) dco_decode_record_string_string(dynamic raw);

  @protected
  (String, int, int?) dco_decode_record_string_u_32_opt_box_autoadd_u_32(
      dynamic raw);

  @protected
  Root dco_decode_root(dynamic raw);

  @protected
  Software dco_decode_software(dynamic raw);

  @protected
  SoftwareCpu dco_decode_software_cpu(dynamic raw);

  @protected
  SoftwareMemory dco_decode_software_memory(dynamic raw);

  @protected
  TableInfo dco_decode_table_info(dynamic raw);

  @protected
  TemplateResult dco_decode_template_result(dynamic raw);

  @protected
  TemplateRunningStage dco_decode_template_running_stage(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  int dco_decode_u_64(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  int dco_decode_usize(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  RustSimpleNotifyLibPinWindowItem
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          SseDeserializer deserializer);

  @protected
  Map<String, String> sse_decode_Map_String_String(
      SseDeserializer deserializer);

  @protected
  RustSimpleNotifyLibPinWindowItem
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<Int64List> sse_decode_StreamSink_list_prim_i_64_strict_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<LLMMessage> sse_decode_StreamSink_llm_message_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<MonitorInfo> sse_decode_StreamSink_monitor_info_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<(Int64List, String)>
      sse_decode_StreamSink_record_list_prim_i_64_strict_string_Sse(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<TemplateResult> sse_decode_StreamSink_template_result_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<TemplateRunningStage>
      sse_decode_StreamSink_template_running_stage_Sse(
          SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  Attributes sse_decode_attributes(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  Attributes sse_decode_box_autoadd_attributes(SseDeserializer deserializer);

  @protected
  CpuInfo sse_decode_box_autoadd_cpu_info(SseDeserializer deserializer);

  @protected
  DatabaseInfo sse_decode_box_autoadd_database_info(
      SseDeserializer deserializer);

  @protected
  EnvParams sse_decode_box_autoadd_env_params(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_i_64(SseDeserializer deserializer);

  @protected
  MemoryInfo sse_decode_box_autoadd_memory_info(SseDeserializer deserializer);

  @protected
  Root sse_decode_box_autoadd_root(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  CellType sse_decode_cell_type(SseDeserializer deserializer);

  @protected
  Children sse_decode_children(SseDeserializer deserializer);

  @protected
  CpuInfo sse_decode_cpu_info(SseDeserializer deserializer);

  @protected
  Data sse_decode_data(SseDeserializer deserializer);

  @protected
  DatabaseInfo sse_decode_database_info(SseDeserializer deserializer);

  @protected
  Delum sse_decode_delum(SseDeserializer deserializer);

  @protected
  Document sse_decode_document(SseDeserializer deserializer);

  @protected
  EnvParams sse_decode_env_params(SseDeserializer deserializer);

  @protected
  double sse_decode_f_32(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  int sse_decode_i_64(SseDeserializer deserializer);

  @protected
  List<RustSimpleNotifyLibPinWindowItem>
      sse_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<Children> sse_decode_list_children(SseDeserializer deserializer);

  @protected
  List<Delum> sse_decode_list_delum(SseDeserializer deserializer);

  @protected
  List<List<TableInfo>> sse_decode_list_list_table_info(
      SseDeserializer deserializer);

  @protected
  List<LLMMessage> sse_decode_list_llm_message(SseDeserializer deserializer);

  @protected
  List<MountedInfo> sse_decode_list_mounted_info(SseDeserializer deserializer);

  @protected
  Int64List sse_decode_list_prim_i_64_strict(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<ProcessPortMapper> sse_decode_list_process_port_mapper(
      SseDeserializer deserializer);

  @protected
  List<(int, String)> sse_decode_list_record_i_64_string(
      SseDeserializer deserializer);

  @protected
  List<(String, CellType)> sse_decode_list_record_string_cell_type(
      SseDeserializer deserializer);

  @protected
  List<(String, String)> sse_decode_list_record_string_string(
      SseDeserializer deserializer);

  @protected
  List<(String, int, int?)>
      sse_decode_list_record_string_u_32_opt_box_autoadd_u_32(
          SseDeserializer deserializer);

  @protected
  List<Software> sse_decode_list_software(SseDeserializer deserializer);

  @protected
  List<SoftwareCpu> sse_decode_list_software_cpu(SseDeserializer deserializer);

  @protected
  List<SoftwareMemory> sse_decode_list_software_memory(
      SseDeserializer deserializer);

  @protected
  List<TableInfo> sse_decode_list_table_info(SseDeserializer deserializer);

  @protected
  LLMMessage sse_decode_llm_message(SseDeserializer deserializer);

  @protected
  MemoryInfo sse_decode_memory_info(SseDeserializer deserializer);

  @protected
  MonitorInfo sse_decode_monitor_info(SseDeserializer deserializer);

  @protected
  MountedInfo sse_decode_mounted_info(SseDeserializer deserializer);

  @protected
  Map<String, String>? sse_decode_opt_Map_String_String(
      SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  Attributes? sse_decode_opt_box_autoadd_attributes(
      SseDeserializer deserializer);

  @protected
  CpuInfo? sse_decode_opt_box_autoadd_cpu_info(SseDeserializer deserializer);

  @protected
  EnvParams? sse_decode_opt_box_autoadd_env_params(
      SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_i_64(SseDeserializer deserializer);

  @protected
  MemoryInfo? sse_decode_opt_box_autoadd_memory_info(
      SseDeserializer deserializer);

  @protected
  Root? sse_decode_opt_box_autoadd_root(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  List<LLMMessage>? sse_decode_opt_list_llm_message(
      SseDeserializer deserializer);

  @protected
  List<MountedInfo>? sse_decode_opt_list_mounted_info(
      SseDeserializer deserializer);

  @protected
  Uint8List? sse_decode_opt_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<SoftwareCpu>? sse_decode_opt_list_software_cpu(
      SseDeserializer deserializer);

  @protected
  List<SoftwareMemory>? sse_decode_opt_list_software_memory(
      SseDeserializer deserializer);

  @protected
  ProcessPortMapper sse_decode_process_port_mapper(
      SseDeserializer deserializer);

  @protected
  (int, String) sse_decode_record_i_64_string(SseDeserializer deserializer);

  @protected
  (Int64List, String) sse_decode_record_list_prim_i_64_strict_string(
      SseDeserializer deserializer);

  @protected
  (String, CellType) sse_decode_record_string_cell_type(
      SseDeserializer deserializer);

  @protected
  (String, String) sse_decode_record_string_string(
      SseDeserializer deserializer);

  @protected
  (String, int, int?) sse_decode_record_string_u_32_opt_box_autoadd_u_32(
      SseDeserializer deserializer);

  @protected
  Root sse_decode_root(SseDeserializer deserializer);

  @protected
  Software sse_decode_software(SseDeserializer deserializer);

  @protected
  SoftwareCpu sse_decode_software_cpu(SseDeserializer deserializer);

  @protected
  SoftwareMemory sse_decode_software_memory(SseDeserializer deserializer);

  @protected
  TableInfo sse_decode_table_info(SseDeserializer deserializer);

  @protected
  TemplateResult sse_decode_template_result(SseDeserializer deserializer);

  @protected
  TemplateRunningStage sse_decode_template_running_stage(
      SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  int sse_decode_usize(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          RustSimpleNotifyLibPinWindowItem self, SseSerializer serializer);

  @protected
  void sse_encode_Map_String_String(
      Map<String, String> self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          RustSimpleNotifyLibPinWindowItem self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_list_prim_i_64_strict_Sse(
      RustStreamSink<Int64List> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_llm_message_Sse(
      RustStreamSink<LLMMessage> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_monitor_info_Sse(
      RustStreamSink<MonitorInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_record_list_prim_i_64_strict_string_Sse(
      RustStreamSink<(Int64List, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_template_result_Sse(
      RustStreamSink<TemplateResult> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_template_running_stage_Sse(
      RustStreamSink<TemplateRunningStage> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_attributes(Attributes self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_attributes(
      Attributes self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_cpu_info(CpuInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_database_info(
      DatabaseInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_env_params(
      EnvParams self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_i_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_memory_info(
      MemoryInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_root(Root self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_cell_type(CellType self, SseSerializer serializer);

  @protected
  void sse_encode_children(Children self, SseSerializer serializer);

  @protected
  void sse_encode_cpu_info(CpuInfo self, SseSerializer serializer);

  @protected
  void sse_encode_data(Data self, SseSerializer serializer);

  @protected
  void sse_encode_database_info(DatabaseInfo self, SseSerializer serializer);

  @protected
  void sse_encode_delum(Delum self, SseSerializer serializer);

  @protected
  void sse_encode_document(Document self, SseSerializer serializer);

  @protected
  void sse_encode_env_params(EnvParams self, SseSerializer serializer);

  @protected
  void sse_encode_f_32(double self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_i_64(int self, SseSerializer serializer);

  @protected
  void
      sse_encode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          List<RustSimpleNotifyLibPinWindowItem> self,
          SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_children(List<Children> self, SseSerializer serializer);

  @protected
  void sse_encode_list_delum(List<Delum> self, SseSerializer serializer);

  @protected
  void sse_encode_list_list_table_info(
      List<List<TableInfo>> self, SseSerializer serializer);

  @protected
  void sse_encode_list_llm_message(
      List<LLMMessage> self, SseSerializer serializer);

  @protected
  void sse_encode_list_mounted_info(
      List<MountedInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_i_64_strict(
      Int64List self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_process_port_mapper(
      List<ProcessPortMapper> self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_i_64_string(
      List<(int, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_string_cell_type(
      List<(String, CellType)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_string_string(
      List<(String, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_string_u_32_opt_box_autoadd_u_32(
      List<(String, int, int?)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_software(List<Software> self, SseSerializer serializer);

  @protected
  void sse_encode_list_software_cpu(
      List<SoftwareCpu> self, SseSerializer serializer);

  @protected
  void sse_encode_list_software_memory(
      List<SoftwareMemory> self, SseSerializer serializer);

  @protected
  void sse_encode_list_table_info(
      List<TableInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_llm_message(LLMMessage self, SseSerializer serializer);

  @protected
  void sse_encode_memory_info(MemoryInfo self, SseSerializer serializer);

  @protected
  void sse_encode_monitor_info(MonitorInfo self, SseSerializer serializer);

  @protected
  void sse_encode_mounted_info(MountedInfo self, SseSerializer serializer);

  @protected
  void sse_encode_opt_Map_String_String(
      Map<String, String>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_attributes(
      Attributes? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_cpu_info(
      CpuInfo? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_env_params(
      EnvParams? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_i_64(int? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_memory_info(
      MemoryInfo? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_root(Root? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_32(int? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_llm_message(
      List<LLMMessage>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_mounted_info(
      List<MountedInfo>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_prim_u_8_strict(
      Uint8List? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_software_cpu(
      List<SoftwareCpu>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_software_memory(
      List<SoftwareMemory>? self, SseSerializer serializer);

  @protected
  void sse_encode_process_port_mapper(
      ProcessPortMapper self, SseSerializer serializer);

  @protected
  void sse_encode_record_i_64_string(
      (int, String) self, SseSerializer serializer);

  @protected
  void sse_encode_record_list_prim_i_64_strict_string(
      (Int64List, String) self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_cell_type(
      (String, CellType) self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_string(
      (String, String) self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_u_32_opt_box_autoadd_u_32(
      (String, int, int?) self, SseSerializer serializer);

  @protected
  void sse_encode_root(Root self, SseSerializer serializer);

  @protected
  void sse_encode_software(Software self, SseSerializer serializer);

  @protected
  void sse_encode_software_cpu(SoftwareCpu self, SseSerializer serializer);

  @protected
  void sse_encode_software_memory(
      SoftwareMemory self, SseSerializer serializer);

  @protected
  void sse_encode_table_info(TableInfo self, SseSerializer serializer);

  @protected
  void sse_encode_template_result(
      TemplateResult self, SseSerializer serializer);

  @protected
  void sse_encode_template_running_stage(
      TemplateRunningStage self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(int self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  factory RustLibWire.fromExternalLibrary(ExternalLibrary lib) =>
      RustLibWire(lib.ffiDynamicLibrary);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustLibWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
      ptr,
    );
  }

  late final _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItemPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'frbgen_all_in_one_rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem');
  late final _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem =
      _rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItemPtr
          .asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
      ptr,
    );
  }

  late final _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItemPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'frbgen_all_in_one_rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem');
  late final _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem =
      _rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItemPtr
          .asFunction<void Function(ffi.Pointer<ffi.Void>)>();
}
