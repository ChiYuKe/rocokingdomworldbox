import 'package:flutter/material.dart';
import 'package:isar/isar.dart'; 

part 'pet_model.g.dart';





enum PetType {
  ordinary(2, Color(0xFF6198B1), "普通"),
  grass(3, Color.fromARGB(255, 84, 202, 123), "草系"),
  fire(4, Color.fromARGB(255, 226, 113, 72), "火系"),
  water(5, Color.fromARGB(255, 106, 169, 254), "水系"),
  light(6, Color(0xFF4FC1FF), "光系"),
  mountain(8, Color(0xFFF8A73D), "地系"),
  ice(9, Color(0xFF4CCCFF), "冰系"),
  dragon(10, Color.fromARGB(255, 237, 73, 98), "龙系"),
  electricity(11, Color(0xFFF0C850), "电系"),
  poison(12, Color(0xFFA364CF), "毒系"),
  insect(13, Color(0xFF97B346), "虫系"),
  valiant(14, Color.fromARGB(255, 255, 150, 54), "武系"),
  wing(15, Color(0xFF47D1DB), "翼系"),
  cute(16, Color(0xFFFF8093), "萌系"),
  dark(17, Color(0xFF9D56CF), "幽系"), 
  evil(18, Color.fromARGB(255, 207, 70, 122), "恶系"),
  mechanical(19, Color(0xFF3EC2A1), "机械系"),
  magical(20, Color(0xFFBDA4FA), "幻系");

  final int id;
  final Color themeColor;
  final String label;

  const PetType(this.id, this.themeColor, this.label);

  // 根据 ID 获取枚举的静态方法
  static PetType? fromId(int id) {
    try {
      return PetType.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

@collection
class PetModel {
  Id isarId = Isar.autoIncrement; // Isar 内部自增主键

  @Index(unique: true, replace: true)
  late int id; // 原始数据中的 ID (如 3001)

  late int lastSyncedVersion; // 记录同步版本
  late String name;
  late int bossType;
  late String moveType;
  late int completeness;
  late List<int> petEvolutionId;
  late int quality;
  late int stengthStage;
  late int stage;
  late int petScroe;
  late int consumeRoleHp;
  late int maxEnergy;
  late List<int> unitType;
  late int showTag;
  late int aiGroupInfoId;
  late int petHabitatGroupRoleType;
  late List<int> ecologyFeature;
  late int levelSkillConfId;
  late int petFeature;
  late int petChaosFeature;
  late int petGlassFeature;
  late int petIdleSkill;
  late int petLackenergySkill;
  late int modelConf;
  late String description;
  late double petScale;
  late int pictorialBookId;
  late int petfreeSort;
  late int petBondId;
  late List<int> petReaction;
  late List<int> evolutionPetId;
  late int bosspetbaseId;
  late List<int> bosspetbaseIdArry;
  late int basePointLimit;
  late int proportionMale;
  late List<int> natureIds;
  late int hpMaxRace;
  late int phyAttackRace;
  late int speAttackRace;
  late int phyDefenceRace;
  late int speDefenceRace;
  late int speedRace;
  late int sumRace;
  late int hpMaxFirst;
  late int phyAttackFirst;
  late int speAttackFirst;
  late int phyDefenceFirst;
  late int speDefenceFirst;
  late int speedFirst;
  late int criticalDam;
  late int grassEnhance;
  late int basePointType;
  late int petUiCameraType;
  late double petpageUiPercentage;
  late List<double> petpageCapsuleOffset;
  late double handbookUiPercentage;
  late List<double> handbookCapsuleOffset;
  late double petUiPercentage;
  late double formationUiScale;
  late List<double> uiCameraOffset;
  late double modelHeight;
  late int showArea;
  late int npcId;
  late int worldNature;
  late int substituteCharacter;
  late int substituteRandomSkill;
  late int catchThresholdBonustime;
  late int catchThresholdBonus;
  late int weightLow;
  late int weightHigh;
  late int heightLow;
  late int heightHigh;
  late int petClassisId;
  late int breakAwardSort;
  late List<int> enjoyFieldType;
  late List<int> hateFieldType;
  late int petSettledBasicReward;
  late int growXIndividuality;
  late int individualityLowerLimit;
  late int individualityUpperLimit;
  late String jlRes;
  late String jlSmallRes;
  late double resUiPercentage;
  late List<double> resOffset;
  late List<double> shadowUiPercentage;
  late List<double> shadowOffset;
  late List<double> shadowAngle;
  late double shadowOpacity;
  late String handbookStandpaintBg;
  late String handbookUnknownBg;
  late String shareBg;
  late String shareUncommonCardFg;
  late String shareUncommonCardBg;
  late String habit1;
  late int petEgg;
  late List<int> eggGroup;
  late int axialDensity; // 修改为 int
  late int radialDensity; // 修改为 int
  late int teamBattleAi; // 修改为 int，修复生成的 .g.dart 冲突
  late double weightCompensation;
  late int talentNormalChance;
  late int talentGoodChance;
  late int talentAmazingChance;
  late int talentPerfectChance;
  late List<int> petTrackNpcId;
  late String petTrackFailDesc;
  late int homeNpcId;
  late int wishNumber;
  late double reportResUiPercentage;
  late List<double> reportResOffset;
  late double cardResUiPercentage;
  late List<double> cardResOffset;
  late int talentRandomId;
  late int audioConfigId;
  late int fallingResistance;
  late int customGlassEggPiece;

  PetModel();

    @enumerated
    List<PetType> get types => unitType
        .map((id) => PetType.fromId(id))
        .whereType<PetType>()
        .toList();


    @ignore   
    Color get mainColor => types.isNotEmpty ? types.first.themeColor : Colors.grey;

    @enumerated
    List<int> get stats => [
      hpMaxRace, // 生命
      phyAttackRace, // 物攻
      speAttackRace, // 魔攻
      phyDefenceRace, // 物防
      speDefenceRace, // 魔防
      speedRace, // 速度
    ];

    @ignore
    List<String> get evolutions => [ "3001", "3002", "3003"
    ];







  factory PetModel.fromJson(Map<String, dynamic> json) {
    // 内部辅助函数：安全转 int
    int asInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // 内部辅助函数：安全转 double
    double asDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // 内部辅助函数：安全转 String
    String asStr(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return PetModel()
      ..id = asInt(json['id'])
      ..lastSyncedVersion = asInt(json['lastSyncedVersion'])
      ..name = asStr(json['name'])
      ..bossType = asInt(json['boss_type'])
      ..moveType = asStr(json['move_type'])
      ..completeness = asInt(json['completeness'])
      ..petEvolutionId = json['pet_evolution_id'] != null ? List<int>.from(json['pet_evolution_id'].map((x) => asInt(x))) : []
      ..quality = asInt(json['quality'])
      ..stengthStage = asInt(json['stength_stage'])
      ..stage = asInt(json['stage'])
      ..petScroe = asInt(json['pet_scroe'])
      ..consumeRoleHp = asInt(json['consume_role_hp'])
      ..maxEnergy = asInt(json['max_energy'])
      ..unitType = json['unit_type'] != null ? List<int>.from(json['unit_type'].map((x) => asInt(x))) : []
      ..showTag = asInt(json['show_tag'])
      ..aiGroupInfoId = asInt(json['ai_group_info_id'])
      ..petHabitatGroupRoleType = asInt(json['pet_habitat_group_role_type'])
      ..ecologyFeature = json['ecology_feature'] != null ? List<int>.from(json['ecology_feature'].map((x) => asInt(x))) : []
      ..levelSkillConfId = asInt(json['level_skill_conf_id'])
      ..petFeature = asInt(json['pet_feature'])
      ..petChaosFeature = asInt(json['pet_chaos_feature'])
      ..petGlassFeature = asInt(json['pet_glass_feature'])
      ..petIdleSkill = asInt(json['pet_idle_skill'])
      ..petLackenergySkill = asInt(json['pet_lackenergy_skill'])
      ..modelConf = asInt(json['model_conf'])
      ..description = asStr(json['description'])
      ..petScale = asDouble(json['pet_scale'])
      ..pictorialBookId = asInt(json['pictorial_book_id'])
      ..petfreeSort = asInt(json['petfree_sort'])
      ..petBondId = asInt(json['pet_bond_id'])
      ..petReaction = json['pet_reaction'] != null ? List<int>.from(json['pet_reaction'].map((x) => asInt(x))) : []
      ..evolutionPetId = json['evolution_pet_id'] != null ? List<int>.from(json['evolution_pet_id'].map((x) => asInt(x))) : []
      ..bosspetbaseId = asInt(json['bosspetbase_id'])
      ..bosspetbaseIdArry = json['bosspetbase_id_arry'] != null ? List<int>.from(json['bosspetbase_id_arry'].map((x) => asInt(x))) : []
      ..basePointLimit = asInt(json['base_point_limit'])
      ..proportionMale = asInt(json['proportion_male'])
      ..natureIds = json['nature_ids'] != null ? List<int>.from(json['nature_ids'].map((x) => asInt(x))) : []
      ..hpMaxRace = asInt(json['hp_max_race'])
      ..phyAttackRace = asInt(json['phy_attack_race'])
      ..speAttackRace = asInt(json['spe_attack_race'])
      ..phyDefenceRace = asInt(json['phy_defence_race'])
      ..speDefenceRace = asInt(json['spe_defence_race'])
      ..speedRace = asInt(json['speed_race'])
      ..sumRace = asInt(json['SUM_race'])
      ..hpMaxFirst = asInt(json['hp_max_first'])
      ..phyAttackFirst = asInt(json['phy_attack_first'])
      ..speAttackFirst = asInt(json['spe_attack_first'])
      ..phyDefenceFirst = asInt(json['phy_defence_first'])
      ..speDefenceFirst = asInt(json['spe_defence_first'])
      ..speedFirst = asInt(json['speed_first'])
      ..criticalDam = asInt(json['critical_dam'])
      ..grassEnhance = asInt(json['grass_enhance'])
      ..basePointType = asInt(json['base_point_type'])
      ..petUiCameraType = asInt(json['pet_ui_camera_type'])
      ..petpageUiPercentage = asDouble(json['petpage_ui_percentage'])
      ..petpageCapsuleOffset = json['petpage_capsule_offset'] != null ? List<double>.from(json['petpage_capsule_offset'].map((x) => asDouble(x))) : []
      ..handbookUiPercentage = asDouble(json['handbook_ui_percentage'])
      ..handbookCapsuleOffset = json['handbook_capsule_offset'] != null ? List<double>.from(json['handbook_capsule_offset'].map((x) => asDouble(x))) : []
      ..petUiPercentage = asDouble(json['pet_ui_percentage'])
      ..formationUiScale = asDouble(json['formation_ui_scale'])
      ..uiCameraOffset = json['ui_camera_offset'] != null ? List<double>.from(json['ui_camera_offset'].map((x) => asDouble(x))) : []
      ..modelHeight = asDouble(json['model_height'])
      ..showArea = asInt(json['show_area'])
      ..npcId = asInt(json['npc_id'])
      ..worldNature = asInt(json['world_nature'])
      ..substituteCharacter = asInt(json['substitute_character'])
      ..substituteRandomSkill = asInt(json['substitute_random_skill'])
      ..catchThresholdBonustime = asInt(json['Catch_Threshold_Bonustime'])
      ..catchThresholdBonus = asInt(json['Catch_Threshold_Bonus'])
      ..weightLow = asInt(json['weight_low'])
      ..weightHigh = asInt(json['weight_high'])
      ..heightLow = asInt(json['height_low'])
      ..heightHigh = asInt(json['height_high'])
      ..petClassisId = asInt(json['pet_classis_id'])
      ..breakAwardSort = asInt(json['break_award_sort'])
      ..enjoyFieldType = json['enjoy_field_type'] != null ? List<int>.from(json['enjoy_field_type'].map((x) => asInt(x))) : []
      ..hateFieldType = json['hate_field_type'] != null ? List<int>.from(json['hate_field_type'].map((x) => asInt(x))) : []
      ..petSettledBasicReward = asInt(json['pet_settled_basic_reward'])
      ..growXIndividuality = asInt(json['grow_x_individuality'])
      ..individualityLowerLimit = asInt(json['individuality_lower_limit'])
      ..individualityUpperLimit = asInt(json['individuality_upper_limit'])
      ..jlRes = asStr(json['JL_res'])
      ..jlSmallRes = asStr(json['JL_small_res'])
      ..resUiPercentage = asDouble(json['res_ui_percentage'])
      ..resOffset = json['res_offset'] != null ? List<double>.from(json['res_offset'].map((x) => asDouble(x))) : []
      ..shadowUiPercentage = json['shadow_ui_percentage'] != null ? List<double>.from(json['shadow_ui_percentage'].map((x) => asDouble(x))) : []
      ..shadowOffset = json['shadow_offset'] != null ? List<double>.from(json['shadow_offset'].map((x) => asDouble(x))) : []
      ..shadowAngle = json['shadow_angle'] != null ? List<double>.from(json['shadow_angle'].map((x) => asDouble(x))) : []
      ..shadowOpacity = asDouble(json['shadow_opacity'])
      ..handbookStandpaintBg = asStr(json['handbook_standpaint_bg'])
      ..handbookUnknownBg = asStr(json['handbook_unknown_bg'])
      ..shareBg = asStr(json['share_bg'])
      ..shareUncommonCardFg = asStr(json['share_uncommon_card_fg'])
      ..shareUncommonCardBg = asStr(json['share_uncommon_card_bg'])
      ..habit1 = asStr(json['habit_1'])
      ..petEgg = asInt(json['pet_egg'])
      ..eggGroup = json['egg_group'] != null ? List<int>.from(json['egg_group'].map((x) => asInt(x))) : []
      ..axialDensity = asInt(json['axial_density'])
      ..radialDensity = asInt(json['radial_density'])
      ..teamBattleAi = asInt(json['team_battle_ai'])
      ..weightCompensation = asDouble(json['weight_compensation'])
      ..talentNormalChance = asInt(json['talent_normal_chance'])
      ..talentGoodChance = asInt(json['talent_good_chance'])
      ..talentAmazingChance = asInt(json['talent_amazing_chance'])
      ..talentPerfectChance = asInt(json['talent_perfect_chance'])
      ..petTrackNpcId = json['pet_track_npc_id'] != null ? List<int>.from(json['pet_track_npc_id'].map((x) => asInt(x))) : []
      ..petTrackFailDesc = asStr(json['pet_track_fail_desc'])
      ..homeNpcId = asInt(json['home_npc_id'])
      ..wishNumber = asInt(json['wish_number'])
      ..reportResUiPercentage = asDouble(json['report_res_ui_percentage'])
      ..reportResOffset = json['report_res_offset'] != null ? List<double>.from(json['report_res_offset'].map((x) => asDouble(x))) : []
      ..cardResUiPercentage = asDouble(json['card_res_ui_percentage'])
      ..cardResOffset = json['card_res_offset'] != null ? List<double>.from(json['card_res_offset'].map((x) => asDouble(x))) : []
      ..talentRandomId = asInt(json['talent_random_id'])
      ..audioConfigId = asInt(json['audio_config_id'])
      ..fallingResistance = asInt(json['falling_resistance'])
      ..customGlassEggPiece = asInt(json['custom_glass_egg_piece']);
  }
}