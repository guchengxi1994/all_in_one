import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/buttons.dart';

class EntryScreen extends ConsumerWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            runSpacing: 15,
            spacing: 15,
            children: [
              watcherButton(ref),
              scheduleButton(ref),
              converterButton(ref)
            ],
          ),
        ),
      ),
    );
  }
}
