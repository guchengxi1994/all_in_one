// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.31.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/process_port_mapper_api.dart';
import 'api/simple.dart';
import 'api/software_monitor_api.dart';
import 'api/sub_window_api.dart';
import 'api/system_monitor_api.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';
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
          wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  RustSimpleNotifyLibPinWindowItem
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic raw);

  @protected
  RustSimpleNotifyLibPinWindowItem
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic raw);

  @protected
  RustStreamSink<Int64List> dco_decode_StreamSink_list_prim_i_64_strict_Sse(
      dynamic raw);

  @protected
  RustStreamSink<MonitorInfo> dco_decode_StreamSink_monitor_info_Sse(
      dynamic raw);

  @protected
  RustStreamSink<(Int64List, String)>
      dco_decode_StreamSink_record_list_prim_i_64_strict_string_Sse(
          dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  CpuInfo dco_decode_box_autoadd_cpu_info(dynamic raw);

  @protected
  MemoryInfo dco_decode_box_autoadd_memory_info(dynamic raw);

  @protected
  CpuInfo dco_decode_cpu_info(dynamic raw);

  @protected
  double dco_decode_f_32(dynamic raw);

  @protected
  int dco_decode_i_64(dynamic raw);

  @protected
  List<RustSimpleNotifyLibPinWindowItem>
      dco_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic raw);

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
  List<Software> dco_decode_list_software(dynamic raw);

  @protected
  List<SoftwareCpu> dco_decode_list_software_cpu(dynamic raw);

  @protected
  List<SoftwareMemory> dco_decode_list_software_memory(dynamic raw);

  @protected
  MemoryInfo dco_decode_memory_info(dynamic raw);

  @protected
  MonitorInfo dco_decode_monitor_info(dynamic raw);

  @protected
  MountedInfo dco_decode_mounted_info(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  CpuInfo? dco_decode_opt_box_autoadd_cpu_info(dynamic raw);

  @protected
  MemoryInfo? dco_decode_opt_box_autoadd_memory_info(dynamic raw);

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
  Software dco_decode_software(dynamic raw);

  @protected
  SoftwareCpu dco_decode_software_cpu(dynamic raw);

  @protected
  SoftwareMemory dco_decode_software_memory(dynamic raw);

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
  RustSimpleNotifyLibPinWindowItem
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          SseDeserializer deserializer);

  @protected
  RustStreamSink<Int64List> sse_decode_StreamSink_list_prim_i_64_strict_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<MonitorInfo> sse_decode_StreamSink_monitor_info_Sse(
      SseDeserializer deserializer);

  @protected
  RustStreamSink<(Int64List, String)>
      sse_decode_StreamSink_record_list_prim_i_64_strict_string_Sse(
          SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  CpuInfo sse_decode_box_autoadd_cpu_info(SseDeserializer deserializer);

  @protected
  MemoryInfo sse_decode_box_autoadd_memory_info(SseDeserializer deserializer);

  @protected
  CpuInfo sse_decode_cpu_info(SseDeserializer deserializer);

  @protected
  double sse_decode_f_32(SseDeserializer deserializer);

  @protected
  int sse_decode_i_64(SseDeserializer deserializer);

  @protected
  List<RustSimpleNotifyLibPinWindowItem>
      sse_decode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          SseDeserializer deserializer);

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
  List<Software> sse_decode_list_software(SseDeserializer deserializer);

  @protected
  List<SoftwareCpu> sse_decode_list_software_cpu(SseDeserializer deserializer);

  @protected
  List<SoftwareMemory> sse_decode_list_software_memory(
      SseDeserializer deserializer);

  @protected
  MemoryInfo sse_decode_memory_info(SseDeserializer deserializer);

  @protected
  MonitorInfo sse_decode_monitor_info(SseDeserializer deserializer);

  @protected
  MountedInfo sse_decode_mounted_info(SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  CpuInfo? sse_decode_opt_box_autoadd_cpu_info(SseDeserializer deserializer);

  @protected
  MemoryInfo? sse_decode_opt_box_autoadd_memory_info(
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
  Software sse_decode_software(SseDeserializer deserializer);

  @protected
  SoftwareCpu sse_decode_software_cpu(SseDeserializer deserializer);

  @protected
  SoftwareMemory sse_decode_software_memory(SseDeserializer deserializer);

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
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          RustSimpleNotifyLibPinWindowItem self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          RustSimpleNotifyLibPinWindowItem self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_list_prim_i_64_strict_Sse(
      RustStreamSink<Int64List> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_monitor_info_Sse(
      RustStreamSink<MonitorInfo> self, SseSerializer serializer);

  @protected
  void sse_encode_StreamSink_record_list_prim_i_64_strict_string_Sse(
      RustStreamSink<(Int64List, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_cpu_info(CpuInfo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_memory_info(
      MemoryInfo self, SseSerializer serializer);

  @protected
  void sse_encode_cpu_info(CpuInfo self, SseSerializer serializer);

  @protected
  void sse_encode_f_32(double self, SseSerializer serializer);

  @protected
  void sse_encode_i_64(int self, SseSerializer serializer);

  @protected
  void
      sse_encode_list_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          List<RustSimpleNotifyLibPinWindowItem> self,
          SseSerializer serializer);

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
  void sse_encode_list_software(List<Software> self, SseSerializer serializer);

  @protected
  void sse_encode_list_software_cpu(
      List<SoftwareCpu> self, SseSerializer serializer);

  @protected
  void sse_encode_list_software_memory(
      List<SoftwareMemory> self, SseSerializer serializer);

  @protected
  void sse_encode_memory_info(MemoryInfo self, SseSerializer serializer);

  @protected
  void sse_encode_monitor_info(MonitorInfo self, SseSerializer serializer);

  @protected
  void sse_encode_mounted_info(MountedInfo self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_cpu_info(
      CpuInfo? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_memory_info(
      MemoryInfo? self, SseSerializer serializer);

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
  void sse_encode_software(Software self, SseSerializer serializer);

  @protected
  void sse_encode_software_cpu(SoftwareCpu self, SseSerializer serializer);

  @protected
  void sse_encode_software_memory(
      SoftwareMemory self, SseSerializer serializer);

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

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
              ptr);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
class RustLibWasmModule implements WasmModule {
  @override
  external Object /* Promise */ call([String? moduleName]);

  @override
  external RustLibWasmModule bind(dynamic thisArg, String moduleName);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockrust_simple_notify_libPinWindowItem(
          dynamic ptr);
}
