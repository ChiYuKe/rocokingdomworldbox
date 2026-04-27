import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'skill_model.g.dart';

/// 技能类型枚举
enum SkillType {
  physical(1, "物理"),
  magic(2, "魔法"),
  change(3, "变化");

  final int id;
  final String label;
  const SkillType(this.id, this.label);

  static SkillType fromId(int id) {
    return SkillType.values.firstWhere((e) => e.id == id, orElse: () => SkillType.physical);
  }
}

@collection
class SkillModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int id; // 技能 ID (如 200000)

  late int lastSyncedVersion;
  late String name;
  late String desc;
  
  late List<int> energyCost; // 消耗
  late List<int> damPara;    // 伤害参数
  
  late int type;             // 属性类型 (火、水等)
  late int skillDamType;     // 1物理 2魔法 3变化
  late int skillFeature;     // 技能特性
  late int damageType;       // 伤害分类
  late int contactType;      // 接触类型
  late int skillPriority;    // 优先度
  late int targetType;       // 目标类型
  late int targetCount;      // 目标数量
  late List<int> cdRound;    // CD回合
  late int hitPara;          // 命中参数
  
  late String resId;         // 资源路径
  late String icon;          // 图标路径 (已通过脚本转换为 assets 路径)

  SkillModel();

  // 辅助获取技能伤害类型枚举
  @ignore
  SkillType get damTypeEnum => SkillType.fromId(skillDamType);

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    String asStr(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return SkillModel()
      ..id = asInt(json['id'])
      ..name = asStr(json['name'])
      ..desc = asStr(json['desc'])
      ..energyCost = json['energy_cost'] != null ? List<int>.from(json['energy_cost'].map((x) => asInt(x))) : []
      ..damPara = json['dam_para'] != null ? List<int>.from(json['dam_para'].map((x) => asInt(x))) : []
      ..type = asInt(json['type'])
      ..skillDamType = asInt(json['skill_dam_type'])
      ..skillFeature = asInt(json['skill_feature'])
      ..damageType = asInt(json['damage_type'])
      ..contactType = asInt(json['contact_type'])
      ..skillPriority = asInt(json['skill_priority'])
      ..targetType = asInt(json['target_type'])
      ..targetCount = asInt(json['target_count'])
      ..cdRound = json['cd_round'] != null ? List<int>.from(json['cd_round'].map((x) => asInt(x))) : []
      ..hitPara = asInt(json['hit_para'])
      ..resId = asStr(json['res_id'])
      ..icon = asStr(json['icon']);
  }
}