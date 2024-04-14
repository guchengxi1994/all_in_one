import 'package:flutter/material.dart';

class AppStyle {
  AppStyle._();
  static const appColor = Color.fromARGB(255, 132, 142, 209);
  static const appColorDark = Color(0xff3c4db3);

  static const appColorLight = Color(0xff91ebef);
  static const appCheckColor = Color(0xff45ce88);
  static const appButtonColor = Color(0xffffcf95);
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

  static const Color black = Color.fromARGB(255, 48, 48, 48);
  static const Color radiantWhite = Color(0xffffffff);
  static const Color white = Color(0xfff0f0f0);
  static const Color bluishGrey = Color(0xffdddee9);
  static const Color navyBlue = Color(0xff6471e9);
  static const Color lightNavyBlue = Color(0xffb3b9ed);
  static const Color red = Color(0xfff96c6c);
  static const Color grey = Color(0xffe0e0e0);

  static TextStyle lunarFesTextStyle = const TextStyle(color: Colors.indigo);
  static TextStyle solarFesTextStyle = const TextStyle(color: Colors.blueGrey);
}
