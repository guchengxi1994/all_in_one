import 'package:flutter/material.dart';
import 'message_box.dart';

class RequestMessageBox extends MessageBox {
  RequestMessageBox({required super.content});

  @override
  Widget toWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 142, 171, 200),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Text(
          content,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
