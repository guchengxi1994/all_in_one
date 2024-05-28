import 'package:all_in_one/layout/styles.dart';
import 'package:all_in_one/llm/global/notifiers/loading_dialog_notifier.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class LoadingDialog extends ConsumerWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loadingDialogProvider);

    WidgetsBinding.instance.addPostFrameCallback((v) async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (ref.read(loadingDialogProvider) == LoadingDialogState.done) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    });
    String stateStr = "";
    // print(state);

    switch (state) {
      case LoadingDialogState.done:
        stateStr = "done";
        break;
      case LoadingDialogState.eval:
        stateStr = "evaluating...";
        break;
      case LoadingDialogState.optimize:
        stateStr = "optimizing...";
        break;
      case LoadingDialogState.format:
        stateStr = "formating...";
        break;
      default:
        stateStr = "evaluating...";
    }

    return Align(
      alignment: Alignment.centerRight,
      child: BlurryContainer(
        width: MediaQuery.of(context).size.width -
            LayoutStyle.sidebarCollapse -
            10,
        height: MediaQuery.of(context).size.height,
        blur: 5,
        elevation: 0,
        color: Colors.transparent,
        padding: const EdgeInsets.all(8),
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        child: Center(
          child: Card(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Text(stateStr),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
