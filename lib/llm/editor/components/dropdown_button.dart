import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class StyleDropdownButton extends StatefulWidget {
  StyleDropdownButton(
      {super.key,
      required this.initial,
      required this.options,
      required this.label}) {
    assert(options.contains(initial));
  }
  final List<String> options;
  final String initial;
  final String label;

  @override
  State<StyleDropdownButton> createState() => StyleDropdownButtonState();
}

class StyleDropdownButtonState extends State<StyleDropdownButton> {
  late String selected = widget.initial;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
            onMenuStateChange: (isOpen) {
              setState(() {
                expanded = isOpen;
              });
            },
            customButton: Container(
              padding: EdgeInsets.all(10),
              width: 125,
              height: 72,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selected),
                      Icon(
                        expanded ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: Colors.redAccent,
              ),
              elevation: 2,
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selected = value;
                });
              }
            },
            items: widget.options
                .map((v) => DropdownMenuItem<String>(value: v, child: Text(v)))
                .toList()),
      ),
    );
  }
}
