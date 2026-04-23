import 'package:flutter/material.dart';
import '../../models/plugin_interface.dart';
import '../../models/pet.dart';
import '../../widgets/plugin_page_template.dart'; // 引入模板
import 'widgets/contrast_ui.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class CalcPlugin implements RocoPlugin {
  final List<Pet> pokedex;
  CalcPlugin({required this.pokedex});

  @override
  String get id => "com.roco.plugin.calc";
  @override
  String get name => "精灵对比";
  @override
  String get description => "对比两只精灵的属性，帮助你更好地了解它们的优劣势";
  @override
  String get version => "V 1.0.0";
  @override
  String get author => "ChiYuKe";

  @override
  bool get isLocked => false; 
  @override
  String get correctKey => dotenv.env['PLUGIN_KEY'] ?? "default_key";  

  @override
  Widget buildIcon(BuildContext context, Color accentColor) {
    return Icon(Icons.analytics_rounded, color: accentColor);
  }

  @override
  Widget buildEntryPage(BuildContext context, Color accentColor) {
    // 使用通用模板包装私有 UI
    return PluginPageTemplate(
      title: name,
      subTitle: description, 
      accentColor: accentColor,
      body: ContrastUI(
        accentColor: accentColor,
        pokedex: pokedex,
      ),
    );
  }
}