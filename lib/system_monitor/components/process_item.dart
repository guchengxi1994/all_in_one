import 'package:all_in_one/styles/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProcessItem extends StatelessWidget {
  const ProcessItem(
      {super.key, required this.name, required this.rate, required this.value});
  final String name;
  final double rate;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  name,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  value,
                  style: const TextStyle(color: AppStyle.appCheckColor),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 270 * rate,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppStyle.appCheckColor,
                AppStyle.red.withOpacity(rate)
              ]),
              borderRadius: BorderRadius.circular(4),
            ),
          )
        ],
      ),
    );
  }
}
