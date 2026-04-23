import 'package:flutter/material.dart';

abstract class RocoPlugin {
  String get id;
  String get name;
  String get description;
  String get version;
  String get author;

  bool get isLocked; 
  String get correctKey;

  // 插件在列表中的图标
  Widget buildIcon(BuildContext context, Color accentColor);

  // 插件的主入口 UI
  Widget buildEntryPage(BuildContext context, Color accentColor);
}