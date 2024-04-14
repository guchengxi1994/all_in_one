import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';

class EntryButton extends StatelessWidget {
  const EntryButton(
      {super.key, required this.onTap, this.icon, required this.name});
  final VoidCallback onTap;
  final Widget? icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(7.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(7.0),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            color: AppStyle.appButtonColor,
            borderRadius: BorderRadius.circular(7.0),
            boxShadow: const [
              BoxShadow(
                color: AppStyle.black,
                offset: Offset(0, 4),
                blurRadius: 10,
                spreadRadius: -3,
              )
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: icon,
              ),
              Text(
                name,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}
