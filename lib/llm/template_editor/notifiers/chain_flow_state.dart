import 'package:collection/collection.dart';

class ChainFlowState {
  final String content;
  final Set<ChainFlowItem> items;

  ChainFlowState({this.items = const {}, this.content = ""});

  ChainFlowState copyWith(Set<ChainFlowItem>? items, String? content) {
    return ChainFlowState(
        items: items ?? this.items, content: content ?? this.content);
  }
}

// class ChainFlowItem {
//   final int start;
//   final int end;
//   final String startContent;
//   final String endContent;

//   ChainFlowItem(
//       {required this.end,
//       required this.endContent,
//       required this.start,
//       required this.startContent});

//   @override
//   bool operator ==(Object other) {
//     if (other is! ChainFlowItem) {
//       return false;
//     }

//     return (start == other.start && end == other.end) ||
//         (start == other.end && end == other.start);
//   }

//   @override
//   int get hashCode =>
//       start.hashCode ^
//       end.hashCode ^
//       startContent.hashCode ^
//       endContent.hashCode;
// }

class ChainFlowItem {
  final List<int> ids;
  final List<String> contents;

  ChainFlowItem({
    required this.ids,
    required this.contents,
  }) {
    assert(ids.length == contents.length);
  }

  @override
  bool operator ==(Object other) {
    if (other is! ChainFlowItem) {
      return false;
    }

    const operator = DeepCollectionEquality();

    return operator.equals(ids, other.ids) &&
        operator.equals(contents, other.contents);
  }

  @override
  int get hashCode => ids.hashCode ^ contents.hashCode;
}
