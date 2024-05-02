import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';

extension FlowElementExtension on FlowElement {
  FlowElement? findPrevious(List<FlowElement> elements) {
    for (final i in elements) {
      if (i.next.map((e) => e.destElementId).contains(id)) {
        return i;
      }
    }

    return null;
  }
}

extension FormatExtension on Dashboard {
  format() {
    if (elements.length < 2) {
      return;
    }

    for (int i = 1; i < elements.length; i++) {
      elements[i].position =
          Offset(elements[0].position.dx + i * 200, elements[0].position.dy);
    }

    recenter();
  }
}
