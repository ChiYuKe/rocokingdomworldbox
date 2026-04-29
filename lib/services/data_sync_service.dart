import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import '../models/skill_model.dart'; 
import '../models/pet_model.dart';
import '../models/sync_config.dart';

class DataSyncService {
  final Isar isar;

  DataSyncService(this.isar);

  /// 统一同步入口
  Future<void> runAllSync() async {


    // 同步 I_PETBASE_CONF.json
    await _syncFileIfNeeded(
      assetPath: 'assets/data/I_PETBASE_CONF.json', 
      fileKey: 'pet_base_conf',
      onSync: (data, version) async {
        final Map<String, dynamic> dataMap = data;
        final List<PetModel> newPetModels = [];
        
        // 逐条解析，方便定位错误
        dataMap.forEach((key, value) {
          try {
            newPetModels.add(
              PetModel.fromJson(value as Map<String, dynamic>)
                ..lastSyncedVersion = version
            );
          } catch (e) {
            debugPrint("错误：宠物 ID $key 解析失败。具体原因: $e");
          }
        });

        // 批量写入数据库
        await isar.writeTxn(() async {
          await isar.petModels.putAll(newPetModels);
        });
        
        debugPrint("I_PETBASE_CONF 同步成功：共 ${newPetModels.length} 条数据");
      },
    );


  // 同步 I_SKILL_CONF.json
    await _syncFileIfNeeded(
      assetPath: 'assets/data/I_SKILL_CONF.json', 
      fileKey: 'skill_conf',
      onSync: (data, version) async {
        final Map<String, dynamic> dataMap = data;
        final List<SkillModel> newSkillModels = [];
        
        dataMap.forEach((key, value) {
          try {
            newSkillModels.add(
              SkillModel.fromJson(value as Map<String, dynamic>)
                ..lastSyncedVersion = version
            );
          } catch (e) {
            debugPrint("错误：技能 ID $key 解析失败。具体原因: $e");
          }
        });

        await isar.writeTxn(() async {
          await isar.skillModels.putAll(newSkillModels);
        });
        
        debugPrint("I_SKILL_CONF 同步成功：共 ${newSkillModels.length} 条数据");
      },
    );

  }


  /// 通用同步处理逻辑
  Future<void> _syncFileIfNeeded({
    required String assetPath,
    required String fileKey,
    required Future<void> Function(dynamic data, int version) onSync,
  }) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> fullJson = json.decode(jsonString);
      final int incomingVersion = fullJson['version'] ?? 0;

      // 1查询现有的配置
      final config = await isar.syncConfigs.where().fileNameEqualTo(fileKey).findFirst();
      final int localVersion = config?.lastSyncedVersion ?? -1;

      if (incomingVersion != localVersion) {
        debugPrint("Service: 正在更新 $fileKey ($localVersion -> $incomingVersion)");
        
        // 执行传入的同步回调
        await onSync(fullJson['data'], incomingVersion);

        // 写入事务：更新版本记录
        await isar.writeTxn(() async {
          final newConfig = SyncConfig()
            ..fileName = fileKey // 现在这里可以正确找到 fileKey 了
            ..lastSyncedVersion = incomingVersion;
          
          // 如果已存在则覆盖记录（确保 ID 一致）
          if (config != null) {
            newConfig.id = config.id; 
          }
          await isar.syncConfigs.put(newConfig);
        });
      } else {
        debugPrint("Service: $fileKey 版本一致，跳过更新");
      }
    } catch (e) {
      debugPrint("Service: $fileKey 同步失败: $e");
    }
  } 
}