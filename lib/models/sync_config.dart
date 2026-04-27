import 'package:isar/isar.dart';

part 'sync_config.g.dart';

@collection
class SyncConfig {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String fileName; // 存储 "pet_base_conf", "skill_conf" 等标识符
  
  late int lastSyncedVersion;
}