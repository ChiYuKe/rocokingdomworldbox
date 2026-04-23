import 'package:flutter/material.dart';
import '../../models/plugin_interface.dart';
import '../../widgets/plugin_page_template.dart'; 
import 'widgets/auto_script_ui.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AutoScriptPlugin implements RocoPlugin {
  
  @override
  String get id => "com.roco.plugin.auto_script";
  @override
  String get name => "自动挂花脚本";
  @override
  String get description => "一个自动挂花脚本，能够自动执行日常任务，提升游戏效率，让你轻松享受游戏乐趣";
  @override
  String get version => "V 1.0.0";
  @override
  String get author => "ChiYuKe";

  @override
  bool get isLocked => true; 

  @override
  String get correctKey => dotenv.env['PLUGIN_AUTO_KEY'] ?? "default_key"; 

  @override
  Widget buildIcon(BuildContext context, Color accentColor) {
    return Icon(Icons.analytics_rounded, color: accentColor);
  }

  @override
  Widget buildEntryPage(BuildContext context, Color accentColor) {
    return PluginPageTemplate(
      title: name,
      subTitle: description, 
      accentColor: accentColor,
      body: AutoScriptUI(
        accentColor: accentColor,
      ),
    );
  }
}