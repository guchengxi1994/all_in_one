import 'package:all_in_one/layout/styles.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  // final stateStream = templateStateStream();
  String state = "evaluating...";

  @override
  void initState() {
    super.initState();
    // stateStream.listen((event) {
    //   if (mounted) {
    //     switch (event) {
    //       case TemplateRunningStage.format:
    //         setState(() {
    //           state = "formating...";
    //         });
    //       case TemplateRunningStage.eval:
    //         setState(() {
    //           state = "evaluating...";
    //         });
    //       case TemplateRunningStage.optimize:
    //         setState(() {
    //           state = "optimizing...";
    //         });
    //       case TemplateRunningStage.done:
    //         setState(() {
    //           state = "done";
    //         });
    //         Future.delayed(const Duration(milliseconds: 500), () {
    //           Navigator.of(context).pop();
    //         });
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
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
                child: Text(state),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
