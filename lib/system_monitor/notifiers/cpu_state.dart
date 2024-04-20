class CpuState {
  final double current;
  final List<double> history;

  CpuState({this.current = 0, this.history = const []});
}
