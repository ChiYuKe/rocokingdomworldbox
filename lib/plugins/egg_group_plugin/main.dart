import 'package:flutter/material.dart';
import '../../models/plugin_interface.dart';
import '../../widgets/plugin_page_template.dart'; 
import 'widgets/egg_group.dart';
import '../../models/pet_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EggGroupPlugin implements RocoPlugin {
  final List<PetModel> allPets;
  EggGroupPlugin({required this.allPets});



  @override
  String get id => "com.roco.plugin.egg_group";
  @override
  String get name => "蛋组计算";
  @override
  String get description => "一个蛋组计算插件";
  @override
  String get version => "V 1.0.0";
  @override
  String get author => "ChiYuKe";

  @override
  bool get isLocked => false; 

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
      body: EggGroupUI(
        accentColor: accentColor,
        allPets: allPets,
      ),
    );
  }
}