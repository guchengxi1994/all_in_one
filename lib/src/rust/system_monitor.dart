// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.31.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class CpuInfo {
  final double current;

  const CpuInfo({
    required this.current,
  });

  @override
  int get hashCode => current.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CpuInfo &&
          runtimeType == other.runtimeType &&
          current == other.current;
}

class MemoryInfo {
  final int used;
  final int total;

  const MemoryInfo({
    required this.used,
    required this.total,
  });

  @override
  int get hashCode => used.hashCode ^ total.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryInfo &&
          runtimeType == other.runtimeType &&
          used == other.used &&
          total == other.total;
}

class MonitorInfo {
  final List<MountedInfo>? disks;
  final MemoryInfo? memory;
  final CpuInfo? cpu;
  final List<SoftwareMemory>? top5Memory;
  final List<SoftwareCpu>? top5Cpu;

  const MonitorInfo({
    this.disks,
    this.memory,
    this.cpu,
    this.top5Memory,
    this.top5Cpu,
  });

  @override
  int get hashCode =>
      disks.hashCode ^
      memory.hashCode ^
      cpu.hashCode ^
      top5Memory.hashCode ^
      top5Cpu.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonitorInfo &&
          runtimeType == other.runtimeType &&
          disks == other.disks &&
          memory == other.memory &&
          cpu == other.cpu &&
          top5Memory == other.top5Memory &&
          top5Cpu == other.top5Cpu;
}

class MountedInfo {
  final String disk;
  final String name;
  final String fs;
  final int available;
  final int total;

  const MountedInfo({
    required this.disk,
    required this.name,
    required this.fs,
    required this.available,
    required this.total,
  });

  @override
  int get hashCode =>
      disk.hashCode ^
      name.hashCode ^
      fs.hashCode ^
      available.hashCode ^
      total.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MountedInfo &&
          runtimeType == other.runtimeType &&
          disk == other.disk &&
          name == other.name &&
          fs == other.fs &&
          available == other.available &&
          total == other.total;
}

class SoftwareCpu {
  final double cpu;
  final String name;

  const SoftwareCpu({
    required this.cpu,
    required this.name,
  });

  @override
  int get hashCode => cpu.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoftwareCpu &&
          runtimeType == other.runtimeType &&
          cpu == other.cpu &&
          name == other.name;
}

class SoftwareMemory {
  final int memory;
  final String name;

  const SoftwareMemory({
    required this.memory,
    required this.name,
  });

  @override
  int get hashCode => memory.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoftwareMemory &&
          runtimeType == other.runtimeType &&
          memory == other.memory &&
          name == other.name;
}
