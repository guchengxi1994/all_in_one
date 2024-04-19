import 'package:all_in_one/src/rust/system_monitor.dart';

class ProcessState {
  final List<SoftwareCpu> cpus;
  final List<SoftwareMemory> memories;

  ProcessState({this.cpus = const [], this.memories = const []});
}
