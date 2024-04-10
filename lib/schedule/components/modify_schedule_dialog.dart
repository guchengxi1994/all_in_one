import 'package:all_in_one/isar/schedule.dart';
import 'package:all_in_one/schedule/extension.dart';
import 'package:all_in_one/schedule/notifier/schedule_notifier.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_duration_picker/time_duration_picker.dart';

class ModifyScheduleDialog extends ConsumerStatefulWidget {
  const ModifyScheduleDialog({super.key, required this.item});
  final ScheduleItem item;

  @override
  ConsumerState<ModifyScheduleDialog> createState() =>
      _ModifyScheduleDialogState();
}

class _ModifyScheduleDialogState extends ConsumerState<ModifyScheduleDialog> {
  late TextEditingController titleController = TextEditingController()
    ..text = widget.item.eventName;

  late TimeOfDay startTime =
      TimeOfDay(hour: widget.item.from.hour, minute: widget.item.from.minute);
  late TimeOfDay endTime =
      TimeOfDay(hour: widget.item.to.hour, minute: widget.item.to.minute);
  bool timeExpanded = false;
  late Color currentColor = widget.item.color;
  bool colorExpanded = false;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        height: colorExpanded || timeExpanded ? 500 : 250,
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
                onExpansionChanged: (value) {
                  setState(() {
                    timeExpanded = value;
                  });
                },
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
                    start: startTime,
                    end: endTime,
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
                onExpansionChanged: (value) {
                  setState(() {
                    colorExpanded = value;
                  });
                },
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    const Text("Pick a color"),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: currentColor),
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
                      pickerColor: currentColor,
                      onColorChanged: (v) {
                        setState(() {
                          currentColor = v;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        if (titleController.text == "") {
                          return;
                        }

                        // print(currentColor);

                        widget.item.color = currentColor;
                        widget.item.eventName = titleController.text;
                        widget.item.from = DateTime(
                            widget.item.from.year,
                            widget.item.from.month,
                            widget.item.from.day,
                            startTime.hour,
                            startTime.minute);
                        widget.item.to = DateTime(
                            widget.item.to.year,
                            widget.item.to.month,
                            widget.item.to.day,
                            endTime.hour,
                            endTime.minute);
                        Navigator.of(context).pop(widget.item);
                      },
                      child: const Text("确定")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ref
                            .read(scheduleProvider.notifier)
                            .deleteSchedule(widget.item.id)
                            .then((_) {
                          Navigator.of(context).pop(null);
                        });
                      },
                      child: const Text("delete"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
