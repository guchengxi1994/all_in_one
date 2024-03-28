import 'package:flutter/material.dart';

class EntryButton extends StatelessWidget {
  const EntryButton(
      {super.key, required this.onTap, required this.icon, this.tooltip = ""});
  final VoidCallback onTap;
  final String icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        // 按钮样式配置
        foregroundColor: Colors.white, backgroundColor: Colors.blue,
        shadowColor: Colors.black.withOpacity(0.1),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: Text('点击我'),
    );
  }
}
