import 'package:flutter/material.dart';

abstract class MessageBox {
  String content;
  MessageBox({required this.content});

  Widget toWidget();
}
