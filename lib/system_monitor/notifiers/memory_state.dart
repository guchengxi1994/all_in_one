import 'package:all_in_one/src/rust/system_monitor.dart';

class MemoryState {
  final MemoryInfo? memoryInfo;
  final List<double> history;

  MemoryState({this.history = const [], this.memoryInfo});
}
