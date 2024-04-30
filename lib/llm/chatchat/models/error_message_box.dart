import 'package:all_in_one/common/color_utils.dart';
import 'package:flutter/material.dart';
import 'message_box.dart';

class ErrorMessageBox extends MessageBox {
  ErrorMessageBox({required super.content});

  @override
  Widget toWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 100,
        height: 75,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ColorUtil.getColorFromHex('#f5f5f5'),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: const Center(
          child: Text(
            "生成失败",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
