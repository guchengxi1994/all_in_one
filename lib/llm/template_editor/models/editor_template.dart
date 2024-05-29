import 'package:langchain_lib/models/template_item.dart';

class EditorTemplate {
  final List<TemplateItem> items;
  EditorTemplate({required this.items});

  List<List<TemplateItem>> intoMultiple() {
    items.sort((a, b) => a.index.compareTo(b.index));
    var vecs = <List<TemplateItem>>[];
    var saved = <int>[];

    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      if (saved.contains(item.index)) {
        continue;
      }

      var subVec = <TemplateItem>[item];
      i++;

      if (item.next == null) {
        saved.add(item.index);
        vecs.add(subVec);
      } else {
        bool foundNext = false;
        for (var next in items) {
          if (saved.contains(next.index)) {
            continue;
          }

          if (item.next == null || foundNext) {
            // The condition seems to be incorrect in the original logic.
            // Assuming the intention was to break after finding all 'next'.
            saved.add(item.index);
            // Removed redundant comment and logic.
            break;
          }

          if (next.index == item.next!) {
            subVec.add(next);
            saved.add(next.index);
            item = next;
            foundNext = true;
          }
        }

        vecs.add(subVec);
      }
    }
    return vecs;
  }
}
