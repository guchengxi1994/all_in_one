class ChainFlowState {
  final String content;
  final Set<ChainFlowItem> items;

  ChainFlowState({this.items = const {}, this.content = ""});

  ChainFlowState copyWith(Set<ChainFlowItem>? items, String? content) {
    return ChainFlowState(
        items: items ?? this.items, content: content ?? this.content);
  }
}

class ChainFlowItem {
  final int start;
  final int end;
  final String startContent;
  final String endContent;

  ChainFlowItem(
      {required this.end,
      required this.endContent,
      required this.start,
      required this.startContent});

  @override
  bool operator ==(Object other) {
    if (other is! ChainFlowItem) {
      return false;
    }

    return (start == other.start && end == other.end) ||
        (start == other.end && end == other.start);
  }

  @override
  int get hashCode =>
      start.hashCode ^
      end.hashCode ^
      startContent.hashCode ^
      endContent.hashCode;
}
