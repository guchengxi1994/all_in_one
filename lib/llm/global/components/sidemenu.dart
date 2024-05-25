import 'package:all_in_one/llm/global/models/sidemenu_item.dart';
import 'package:flutter/material.dart';

class Sidemenu extends StatefulWidget {
  const Sidemenu(
      {super.key, required this.items, this.width = 200, this.footer});
  final List<SidemenuItem> items;
  final double width;
  final SidemenuItem? footer;

  @override
  State<Sidemenu> createState() => _SidemenuState();
}

class _SidemenuState extends State<Sidemenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(255, 237, 232, 236),
            Color.fromARGB(255, 221, 221, 245)
          ])),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemBuilder: (c, i) {
              return widget.items[i].toWidget();
            },
            itemCount: widget.items.length,
          )),
          if (widget.footer != null)
            widget.footer!.toWidget()
          else
            const SizedBox()
        ],
      ),
    );
  }
}
