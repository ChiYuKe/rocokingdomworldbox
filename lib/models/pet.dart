import 'package:flutter/material.dart';
import 'package:isar/isar.dart'; 

part 'pet.g.dart'; 

enum PetType {
  fire(Color(0xFFBD4A20), "火系"),
  water(Color.fromARGB(255, 40, 158, 255), "水系"),
  grass(Color.fromARGB(255, 78, 188, 115), "草系"),
  light(Color.fromARGB(255, 79, 193, 255), "光系"),
  ordinary(Color.fromARGB(255, 97, 152, 177), "普通"),
  dragon(Color.fromARGB(255, 228, 43, 43), "龙系"),
  poison(Color.fromARGB(255, 163, 100, 207), "毒系"),
  insect(Color.fromARGB(255, 151, 179, 70), "虫系"),
  valiant(Color.fromARGB(255, 255, 129, 79), "武系"),
  wing(Color.fromARGB(255, 71, 209, 219), "翼系"),
  cute(Color.fromARGB(255, 255, 128, 147), "萌系"),
  evil(Color.fromARGB(255, 233, 64, 120), "恶系"),
  mechanical(Color.fromRGBO(62, 194, 161, 1), "机械系"),
  magical(Color.fromARGB(255, 189, 164, 250), "幻系"),
  electricity(Color.fromARGB(255, 240, 200, 80), "电系"),
  dark(Color.fromARGB(255, 157, 86, 207), "幽系"),
  mountain(Color.fromARGB(255, 248, 167, 61), "地系"),
  ice(Color.fromARGB(255, 76, 204, 255), "冰系");


  final Color themeColor;
  final String label;
  const PetType(this.themeColor, this.label);
}
// 如果改了数据模型，记得在终端执行 dart run build_runner build --delete-conflicting-outputs 来更新生成的代码






/// 
///    等级技能 LEVEL_SKILL_CONF.json    纹理  SKILL_CONF.json
/// "pet_evolution_id": [ 4 ],  对应  PET_EVOLUTION_CONF.json
///
/// "pet_feature": 200076,  "pet_chaos_feature": 200076,   "pet_glass_feature": 200076,  对应  SKILL_CONF.json
///
///
/// "pet_egg": 对应 BAG_ITEM_CONF.json
///
///
///

















// 定义 Ability 数据模型
@collection
class Ability {
  Id id = Isar.autoIncrement; 

  @Index(unique: true, replace: true)
  late String aid; 
  
  late String name;
  late String description;
  late String image;
}


// 定义 Pet 数据模型
@collection
class Pet {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String petId;
  
  late String name;
  
  @enumerated
  late List<PetType> types;
  late List<double> stats; 
  late List<String> evolutions;

  String? height;
  String? weight;
  String? location;
  String? description;
  String? abilityId;

  static Pet fromJson(Map<String, dynamic> json) {
    return Pet()
      ..petId = json['id'].toString()
      ..name = json['name'] ?? '未知'
      ..types = (json['types'] as List?)
              ?.map((t) => PetType.values.firstWhere(
                    (e) => e.name.toLowerCase() == t.toString().toLowerCase(),
                    orElse: () => PetType.ordinary, // 如果匹配不到给个默认系
                  ))
              .toList() ?? []
      ..stats = (json['stats'] as List?)
              ?.map((x) => (x as num).toDouble())
              .toList() ?? []
      ..evolutions = List<String>.from(json['evolutions'] ?? [])
      ..height = json['height']
      ..weight = json['weight']
      ..location = json['location']
      ..description = json['description']
      ..abilityId = json['abilityId'];
  }
}