import 'package:flutter/material.dart';

class AutoScriptUI extends StatefulWidget {
  final Color accentColor;

  const AutoScriptUI({super.key, required this.accentColor});

  @override
  State<AutoScriptUI> createState() => _AutoScriptUIState();
}

class _AutoScriptUIState extends State<AutoScriptUI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "自动脚本功能正在开发中，敬请期待！",
        style: TextStyle(fontSize: 18, color: widget.accentColor),
      ),
    );
  }




}