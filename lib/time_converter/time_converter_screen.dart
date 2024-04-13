import 'package:all_in_one/styles/app_style.dart';
import 'package:all_in_one/time_converter/extension.dart';
import 'package:flutter/material.dart';
import 'package:lunar/lunar.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeConverterScreen extends StatefulWidget {
  const TimeConverterScreen({super.key});

  @override
  State<TimeConverterScreen> createState() => _TimeConverterScreenState();
}

class _TimeConverterScreenState extends State<TimeConverterScreen> {
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  int? current = 0;
  String? lunar = "";

  List<String> timeZoneIds = [
    'America/New_York',
    'Europe/London',
    'Asia/Shanghai',
    'Australia/Sydney',
  ];

  // final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    yearController.text = now.year.toString();
    monthController.text = now.month.toString();
    dayController.text = now.day.toString();
    hourController.text = now.hour.toString();
    minuteController.text = now.minute.toString();
    secondController.text = now.second.toString();

    current = now.millisecondsSinceEpoch;
    lunar =
        Lunar.fromDate(DateTime(now.year, now.month, now.day)).toFormatString();
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200]!,
      child: Container(
        margin: const EdgeInsets.all(50),
        padding: const EdgeInsets.all(20),
        // width: 0.8 * MediaQuery.of(context).size.width,
        // height: 0.8 * MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppStyle.appColor),
            boxShadow: const [
              BoxShadow(
                color: AppStyle.black,
                offset: Offset(0, 4),
                blurRadius: 10,
                spreadRadius: -3,
              )
            ]),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _textEditWrapper(yearController, (_) => _onTextChanged(),
                      hint: "year"),
                  const Text("年 "),
                  _textEditWrapper(monthController, (_) => _onTextChanged(),
                      hint: "month"),
                  const Text("月 "),
                  _textEditWrapper(dayController, (_) => _onTextChanged(),
                      hint: "day"),
                  const Text("日 "),
                  _textEditWrapper(hourController, (_) => _onTextChanged(),
                      hint: "hour"),
                  const Text("时 "),
                  _textEditWrapper(minuteController, (_) => _onTextChanged(),
                      hint: "minute"),
                  const Text("分 "),
                  _textEditWrapper(secondController, (_) => _onTextChanged(),
                      hint: "second"),
                  const Text("秒 "),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text("Unix time: "),
                  SelectableText(current.toString()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("lunar time: "),
                  SelectableText(lunar.toString())
                ],
              ),
              ...timeZoneIds.map((e) {
                final utcNow = tz.TZDateTime.from(
                    DateTime.fromMillisecondsSinceEpoch(current ?? 0),
                    tz.getLocation(e));
                return Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(e),
                    ),
                    SelectableText(utcNow.toString())
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  _onTextChanged() {
    try {
      DateTime dateTime = DateTime(
          int.parse(yearController.text),
          int.parse(monthController.text),
          int.parse(dayController.text),
          int.parse(hourController.text),
          int.parse(minuteController.text),
          int.parse(secondController.text));

      current = dateTime.millisecondsSinceEpoch;
      lunar = Lunar.fromDate(DateTime(int.parse(yearController.text),
              int.parse(monthController.text), int.parse(dayController.text)))
          .toFormatString();
    } catch (_) {
      current = null;
      lunar = null;
    }
    // print("current  $current");
    setState(() {});
  }

  _textEditWrapper(
      TextEditingController controller, ValueChanged<String> onChange,
      {String? hint}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 60,
      height: 30,
      child: TextField(
        decoration: InputDecoration(
            hintText: hint,
            errorStyle: const TextStyle(height: 0),
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 10, bottom: 15),
            border: InputBorder.none,
            // focusedErrorBorder:
            //     OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppStyle.appColor)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppStyle.appColor)),
            enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 159, 159, 159)))),
        controller: controller,
        onChanged: (v) => onChange(v),
      ),
    );
  }
}
