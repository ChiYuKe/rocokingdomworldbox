import 'package:isar/isar.dart'; 

part 'chat_message.g.dart';

@collection
class ChatMessage {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId; // Supabase 中的 uuid


  @Index()
  String? channelName; // 用于区分不同频道的历史记录

  @Index(unique: true, replace: true) // replace: true 表示如果冲突了就覆盖，进一步防止死机
  String? remoteChannelKey;

  String? content;
  String? username;
  String? userId;
  int? petId;
  bool isImage = false;
  DateTime? createdAt;
  
  // 乐观更新状态：0-成功, 1-发送中, 2-失败
  int status = 0; 

  // 简单的回复信息存储（转为 JSON 字符串或嵌入类）
  String? replyToData; 
}