import 'package:flutter/material.dart';

class AppStyle {
  AppStyle._();
  static const appColor = Color.fromARGB(255, 114, 245, 241);
  static const InputDecoration inputDecoration = InputDecoration(
      errorStyle: TextStyle(height: 0),
      hintStyle:
          TextStyle(color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
      contentPadding: EdgeInsets.only(left: 10, bottom: 15),
      border: InputBorder.none,
      // focusedErrorBorder:
      //     OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: AppStyle.appColor)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: AppStyle.appColor)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 159, 159, 159))));
}
