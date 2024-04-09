import 'package:all_in_one/schedule/extension.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:time_duration_picker/time_duration_picker.dart';

class NewScheduleDialog extends StatefulWidget {
  const NewScheduleDialog({super.key});

  @override
  State<NewScheduleDialog> createState() => _NewScheduleDialogState();
}

class _NewScheduleDialogState extends State<NewScheduleDialog> {
  final TextEditingController titleController = TextEditingController();

  List<DateTime?> dates = [DateTime.now()];
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 12, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        height: 500,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: "Input title",
                    errorStyle: TextStyle(height: 0),
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159),
                        fontSize: 12),
                    contentPadding: EdgeInsets.only(left: 10, bottom: 15),
                    border: InputBorder.none,
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppStyle.appColor)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppStyle.appColor)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 159, 159, 159)))),
              ),
              ExpansionTile(
                shape: const Border(
                  top: BorderSide.none,
                  bottom: BorderSide.none,
                ),
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                title: Container(
                  padding: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 159, 159, 159)),
                      borderRadius: BorderRadius.circular(4)),
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: dates.isNotEmpty
                        ? Text(dates
                            .map((e) => e == null
                                ? ""
                                : "${e.year}-${e.month}-${e.day}")
                            .toList()
                            .join(" ~ "))
                        : const Text(
                            "Select dates",
                            style: TextStyle(
                                color: Color.fromARGB(255, 159, 159, 159),
                                fontSize: 12),
                          ),
                  ),
                ),
                children: [
                  CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.range,
                    ),
                    value: dates,
                    onValueChanged: (d) {
                      if (d.length == 1 || d.length == 2) {
                        setState(() {
                          dates = d;
                        });
                        // print(d);
                      }
                    },
                  )
                ],
              ),
              ExpansionTile(
                shape: const Border(
                  top: BorderSide.none,
                  bottom: BorderSide.none,
                ),
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                title: Container(
                  padding: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 159, 159, 159)),
                      borderRadius: BorderRadius.circular(4)),
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "${startTime.format(context)} ~ ${endTime.format(context)}"),
                  ),
                ),
                children: [
                  TimeDurationPicker(
                    diameter: 260,
                    icon1Data: Icons.notifications_none,
                    icon2Data: Icons.done_all,
                    knobDecoration: const BoxDecoration(
                        color: Color.fromRGBO(167, 153, 240, 1)),
                    clockDecoration: const BoxDecoration(
                        gradient: RadialGradient(colors: [
                      Color.fromRGBO(167, 153, 240, 1),
                      Colors.white
                    ])),
                    knobBackgroundDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(218, 224, 238, 1),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.white,
                          Color.fromRGBO(218, 224, 238, 1),
                        ],
                        stops: [0.1, 1],
                      ),
                    ),
                    onIcon1RotatedCallback: (value) {
                      // print("onIcon1RotatedCallback " + value);
                      // print(value.toTime());
                      setState(() {
                        startTime = value.toTime() ??
                            const TimeOfDay(hour: 0, minute: 0);
                      });
                    },
                    onIcon2RotatedCallback: (value) {
                      // print("onIcon2RotatedCallback " + value);
                      setState(() {
                        endTime = value.toTime() ??
                            const TimeOfDay(hour: 12, minute: 0);
                      });
                    },
                    setDurationCallback: (value) {},
                  ),
                ],
              ),
              ExpansionTile(
                shape: const Border(
                  top: BorderSide.none,
                  bottom: BorderSide.none,
                ),
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    const Text("Pick a color"),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppStyle.appColor),
                    )
                  ],
                ),
                children: [
                  SlidePicker(
                      colorModel: ColorModel.rgb,
                      enableAlpha: false,
                      displayThumbColor: true,
                      showParams: true,
                      showIndicator: true,
                      pickerColor: AppStyle.appColor,
                      onColorChanged: (v) {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
