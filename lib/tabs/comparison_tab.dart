import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:isar/isar.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; 
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/chat_message.dart';

final String DEVELOPER_ID = dotenv.env['DEVELOPER_USER_ID'] ?? "default_key";

class ComparisonTab extends StatefulWidget {
  final Color accentColor;
  final Isar isar;

  const ComparisonTab({
    super.key,
    required this.accentColor,
    required this.isar,
  });

  @override
  State<ComparisonTab> createState() => ComparisonTabState();
}

class ComparisonTabState extends State<ComparisonTab> {
  SupabaseClient? _activeClient;
  
  final TextEditingController _textController = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  final FocusNode _focusNode = FocusNode();

  late CacheManager customCacheManager;
  String? _downloadDirPath;

  String _username = "";
  int _avatarIndex = 0;
  String _userId = "";
  int _onlineCount = 0;
  
  List<Map<String, String>> _customChannels = [];
  String _currentChannelName = "基础频道";

  RealtimeChannel? _presenceChannel;
  StreamSubscription? _supabaseSubscription;

  Map<String, dynamic>? _replyingTo;
  bool _isSending = false;
  bool _isDragging = false;
  String? _highlightedMsgId;
  bool _isInitialized = false;

  bool _isManualJumping = false;
  bool _showScrollToBottomBtn = false; 
  bool _hasNewMessage = false;
  bool _isAtBottom = true;

  final Map<String, ValueNotifier<double?>> _downloadProgressMap = {};

  bool _currentChannelAllowAll = false;
  List<String> _currentChannelAllowedIds = [];

  bool get _canSendFile {
    if (_userId == DEVELOPER_ID) return true; 
    if (_currentChannelAllowAll) return true; 
    return _currentChannelAllowedIds.contains(_userId); 
  }

  final List<IconData> _avatars = [
    Icons.auto_awesome,
    Icons.local_fire_department,
    Icons.water_drop,
    Icons.bolt,
    Icons.grass,
    Icons.shield,
  ];

  Stream<List<ChatMessage>>? _isarMessageStream;
  DateTime? _lastClearTime;

  @override
  void initState() {
    super.initState();
    initialize();
    _setupScrollListener();
  }

  // 修改后的滚动监听逻辑
  void _setupScrollListener() {
    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isEmpty) return;

      // 获取当前可视范围内最大的索引及其偏移量
      final lastVisibleItem = positions
          .where((p) => p.itemTrailingEdge > 0)
          .reduce((max, p) => p.index > max.index ? p : max);

      final totalCount = widget.isar.chatMessages
          .filter()
          .channelNameEqualTo(_currentChannelName)
          .countSync();

      // 判断逻辑：如果最大可见索引接近最后一条，或者最后一条已经在视野内
      // 我们增加一个 buffer，比如距离底部还剩 1 条消息时也认为是在底部
      bool atBottomNow = (lastVisibleItem.index >= totalCount - 2);

      if (atBottomNow != _isAtBottom) {
        setState(() {
          _isAtBottom = atBottomNow;
          if (_isAtBottom) {
            _showScrollToBottomBtn = false;
            _hasNewMessage = false; 
          } else {
            _showScrollToBottomBtn = true;
          }
        });
      }
    });
  }

  Future<void> _preparePaths() async {
    final tempDir = await getTemporaryDirectory();
    final cachePath = p.join(tempDir.path, 'RocoKingdomCache');
    final baseDir = Directory.current.path;
    _downloadDirPath = p.join(baseDir, 'RocoDownloads');
    final downloadDir = Directory(_downloadDirPath!);
    if (!downloadDir.existsSync()) downloadDir.createSync(recursive: true);

    customCacheManager = CacheManager(
      Config(
        'RocoKingdomCache',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 200, 
        repo: JsonCacheInfoRepository(databaseName: 'RocoKingdomCache'),
        fileSystem: IOFileSystem(cachePath), 
        fileService: HttpFileService(),
      ),
    );
  }

  Future<String> _getUniqueId() async {
    final prefs = await SharedPreferences.getInstance();
    String? existingId = prefs.getString('userId');
    if (existingId != null && !existingId.startsWith('user_')) {
      return existingId;
    }

    final deviceInfo = DeviceInfoPlugin();
    String finalId = "user_${Random().nextInt(999999)}";

    try {
      if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        finalId = windowsInfo.deviceId.replaceAll('{', '').replaceAll('}', '');
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        finalId = androidInfo.id;
      }
    } catch (e) {
      debugPrint("获取设备唯一标识失败: $e");
    }

    await prefs.setString('userId', finalId);
    return finalId;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _preparePaths();
    
    final machineId = await _getUniqueId();
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final savedUsername = prefs.getString('username') ?? "";
    final savedAvatarIndex = prefs.getInt('avatarIndex') ?? 0;
    
    final clearTimeStr = prefs.getString('clear_time_$_currentChannelName');
    if (clearTimeStr != null) {
      _lastClearTime = DateTime.tryParse(clearTimeStr);
    }

    final channelsJson = prefs.getString('custom_channels');
    if (channelsJson != null) {
      _customChannels = List<Map<String, String>>.from(
        (jsonDecode(channelsJson) as List).map((e) => Map<String, String>.from(e))
      );
    }

    setState(() {
      _userId = machineId;
      _username = savedUsername;
      _avatarIndex = savedAvatarIndex;
      _isInitialized = true;
      _activeClient = Supabase.instance.client;
    });

    _updateMessageStream();
    _fetchChannelConfig(); 
    _startSyncing();
    _setupPresence();
  }

  Future<void> _fetchChannelConfig() async {
    if (_activeClient == null) return;
    try {
      final data = await _activeClient!
          .from('channel_configs')
          .select('allow_all_files, allowed_machine_ids')
          .eq('channel_name', _currentChannelName)
          .maybeSingle();

      if (data != null) {
        setState(() {
          _currentChannelAllowAll = data['allow_all_files'] ?? false;
          _currentChannelAllowedIds = List<String>.from(data['allowed_machine_ids'] ?? []);
        });
      } else {
        setState(() {
          _currentChannelAllowAll = false;
          _currentChannelAllowedIds = [];
        });
      }
    } catch (e) {
      debugPrint("获取权限配置发生错误: $e");
    }
  }

  void _updateMessageStream() {
    setState(() {
      _isarMessageStream = widget.isar.chatMessages
          .filter()
          .channelNameEqualTo(_currentChannelName)
          .sortByCreatedAt()
          .watch(fireImmediately: true);
    });
  }

  @override
  void dispose() {
    _supabaseSubscription?.cancel();
    if (_presenceChannel != null) _activeClient?.removeChannel(_presenceChannel!);
    _textController.dispose();
    _focusNode.dispose();
    for (var notifier in _downloadProgressMap.values) notifier.dispose();
    super.dispose();
  }

  Future<void> _clearChatHistory() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text("彻底清空", style: TextStyle(color: Colors.white)),
        content: Text("确定要清空频道 [$_currentChannelName] 的所有记录并清理本地缓存吗？"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("取消")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("全部清空", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final now = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('clear_time_$_currentChannelName', now.toIso8601String());
      
      await widget.isar.writeTxn(() async {
        await widget.isar.chatMessages
            .filter()
            .channelNameEqualTo(_currentChannelName)
            .deleteAll();
      });

      try {
        await customCacheManager.emptyCache();
      } catch (e) {
        debugPrint("清理缓存文件失败: $e");
      }

      setState(() {
        _lastClearTime = now;
        _downloadProgressMap.clear();
      });

      _showSuccessSnackBar("记录与缓存已彻底清空");
      _updateMessageStream();
    }
  }

  String _generateRoomCode(String name, String url, String key) {
    final Map<String, String> data = {'n': name, 'u': url, 'k': key};
    return base64Encode(utf8.encode(jsonEncode(data)));
  }

  void _joinChannelByCode(String code) async {
    try {
      final decoded = jsonDecode(utf8.decode(base64Decode(code.trim())));
      final String name = decoded['n'];
      final String url = decoded['u'];
      final String key = decoded['k'];

      if (_customChannels.any((element) => element['name'] == name)) {
        _showErrorSnackBar("频道已存在");
        return;
      }

      final newChannel = {'name': name, 'url': url, 'key': key};
      setState(() => _customChannels.add(newChannel));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('custom_channels', jsonEncode(_customChannels));
      
      _switchChannel(name, url: url, key: key);
      _showSuccessSnackBar("成功通过房间码加入: $name");
    } catch (e) {
      _showErrorSnackBar("无效的房间码");
    }
  }

  void _showSuccessSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating)
    );
  }

  Future<void> _handleDownload(String url, String msgId) async {
    final notifier = _downloadProgressMap.putIfAbsent(msgId, () => ValueNotifier<double?>(null));
    if (notifier.value != null && notifier.value! >= 0) return;

    try {
      String originalName = Uri.decodeFull(p.basename(url)).split('_').last;
      String destinationPath = p.join(_downloadDirPath!, originalName);
      File targetFile = File(destinationPath);

      if (targetFile.existsSync()) {
        notifier.value = -1.0; 
        _showSuccessSnackBar("文件已存在于下载目录");
        return;
      }

      Stream<FileResponse> fileStream = customCacheManager.getFileStream(url, withProgress: true);
      await for (final response in fileStream) {
        if (response is DownloadProgress) {
          notifier.value = response.progress;
        } else if (response is FileInfo) {
          File cachedFile = response.file;
          await cachedFile.copy(destinationPath);
          notifier.value = -1.0; 
        }
      }
    } catch (e) {
      notifier.value = null;
      _showErrorSnackBar("下载失败: $e");
    }
  }

  Future<void> _openFileLocation(String url) async {
    try {
      final String originalName = Uri.decodeFull(p.basename(url)).split('_').last;
      final String filePath = p.join(_downloadDirPath!, originalName);
      final file = File(filePath);
      if (!file.existsSync()) {
        _showErrorSnackBar("文件不存在，请先下载");
        return;
      }
      await Process.start('explorer', ['/select,', file.path]);
    } catch (e) {
      _showErrorSnackBar("无法打开文件所在位置");
    }
  }

  Future<void> _switchChannel(String name, {String? url, String? key}) async {
    await _supabaseSubscription?.cancel();
    _supabaseSubscription = null;
    if (_presenceChannel != null) {
      await _activeClient?.removeChannel(_presenceChannel!);
      _presenceChannel = null;
    }

    final prefs = await SharedPreferences.getInstance();
    final clearTimeStr = prefs.getString('clear_time_$name');

    setState(() {
      _currentChannelName = name;
      _lastClearTime = clearTimeStr != null ? DateTime.tryParse(clearTimeStr) : null;
      _onlineCount = 0;
      _isarMessageStream = null;
      _currentChannelAllowAll = false;
      _currentChannelAllowedIds = [];
      _hasNewMessage = false;
      _showScrollToBottomBtn = false;
      
      if (url != null && key != null) {
        _activeClient = SupabaseClient(url, key);
      } else {
        _activeClient = Supabase.instance.client;
      }
    });

    _updateMessageStream();
    _fetchChannelConfig(); 
    _startSyncing();
    _setupPresence();
  }

  // 修改后的同步逻辑
  void _startSyncing() {
    if (_activeClient == null) return;
    final String syncContextChannel = _currentChannelName;
    _supabaseSubscription = _activeClient!
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .listen((List<Map<String, dynamic>> data) async {
      if (syncContextChannel != _currentChannelName) return;
      
      await widget.isar.writeTxn(() async {
        for (var map in data) {
          final createdAt = DateTime.parse(map['created_at']).toLocal();
          if (_lastClearTime != null && createdAt.isBefore(_lastClearTime!)) continue;

          final remoteId = map['id'].toString();
          final String combinedKey = "${remoteId}_$syncContextChannel";
          
          // 检查 Isar 中是否已存在（避免重复插入引发的 UI 跳动）
          final existing = await widget.isar.chatMessages
              .filter()
              .remoteChannelKeyEqualTo(combinedKey)
              .findFirst();

          if (existing != null) continue;

          final msg = ChatMessage()
            ..remoteId = remoteId
            ..channelName = syncContextChannel
            ..remoteChannelKey = combinedKey
            ..content = map['content']
            ..username = map['username']
            ..userId = map['user_id']
            ..petId = map['pet_id']
            ..isImage = map['is_image'] ?? false
            ..createdAt = createdAt
            ..replyToData = map['reply_to'] != null ? jsonEncode(map['reply_to']) : null
            ..status = 0;
          await widget.isar.chatMessages.put(msg);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (msg.userId == _userId) {
              // 只有当是“发送”操作触发的同步，或者就在底部时才跳转
              if (_isAtBottom || _isManualJumping) {
                 _scrollToBottom();
              }
            } else {
              if (_isAtBottom) {
                _scrollToBottom();
              } else {
                if (mounted) setState(() => _hasNewMessage = true);
              }
            }
          });
        }
      });
    });
  }

  void _setupPresence() {
    if (_activeClient == null) return;
    _presenceChannel = _activeClient!.channel('online-users-$_currentChannelName');
    _presenceChannel?.onPresenceSync((payload) {
      if (!mounted) return;
      final states = _presenceChannel?.presenceState() ?? [];
      setState(() => _onlineCount = states.length);
    }).subscribe((status, [error]) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        await _presenceChannel?.track({'user_id': _userId, 'username': _username});
      }
    });
  }

  void _deleteChannel(String name) async {
    setState(() => _customChannels.removeWhere((element) => element['name'] == name));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_channels', jsonEncode(_customChannels));
    if (_currentChannelName == name) _switchChannel("基础频道");
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _activeClient == null) return;
    if (_username.isEmpty) { _showProfileDialog(isFirstTime: true); return; }
    
    final tempReply = _replyingTo;
    _textController.clear();
    _clearReplyState();

    _isManualJumping = true;
    final localMsg = await _insertOptimisticMessage(text, false);

    _scrollToBottom();

    try {
      final response = await _activeClient!.from('messages').insert({
        'content': text,
        'username': _username,
        'user_id': _userId, 
        'pet_id': _avatarIndex,
        'is_image': false,
        'reply_to': tempReply,
        'channel_name': _currentChannelName,
      }).select().single();

      final String realRemoteId = response['id'].toString();
      await widget.isar.writeTxn(() async {
        await widget.isar.chatMessages.delete(localMsg.id);
        localMsg.remoteId = realRemoteId;
        localMsg.remoteChannelKey = "${realRemoteId}_$_currentChannelName";
        localMsg.status = 0; 
        await widget.isar.chatMessages.put(localMsg);
      });
    } catch (e) {
      await widget.isar.writeTxn(() async {
        localMsg.status = 2; 
        await widget.isar.chatMessages.put(localMsg);
      });
    } finally {
      // 延迟重置，确保同步流回来的消息能匹配到这个状态
      Future.delayed(const Duration(milliseconds: 500), () {
        _isManualJumping = false;
      });
    }
  }

  Future<void> _uploadAndSendFile(File file) async {
    if (_activeClient == null || !_canSendFile) {
      _showErrorSnackBar("您没有权限在该频道发送文件");
      return;
    }
    if (_username.isEmpty) { _showProfileDialog(isFirstTime: true); return; }
    
    final ext = p.extension(file.path).toLowerCase();
    final isImage = ['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(ext);
    
    _isManualJumping = true;
    final localMsg = await _insertOptimisticMessage(file.path, isImage);
    
    _scrollToBottom();

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';
    final filePath = 'chat_files/$fileName';

    try {
      await _activeClient!.storage.from('chat').upload(filePath, file);
      final String fileUrl = _activeClient!.storage.from('chat').getPublicUrl(filePath);
      final response = await _activeClient!.from('messages').insert({
        'content': fileUrl,
        'username': _username,
        'user_id': _userId,
        'pet_id': _avatarIndex,
        'is_image': isImage,
        'reply_to': _replyingTo,
        'channel_name': _currentChannelName,
      }).select().single();

      final String realRemoteId = response['id'].toString();
      await widget.isar.writeTxn(() async {
        await widget.isar.chatMessages.delete(localMsg.id);
        localMsg.remoteId = realRemoteId;
        localMsg.remoteChannelKey = "${realRemoteId}_$_currentChannelName";
        localMsg.status = 0;
        localMsg.content = fileUrl; 
        await widget.isar.chatMessages.put(localMsg);
      });
      _clearReplyState();
    } catch (e) {
      await widget.isar.writeTxn(() async {
        localMsg.status = 2;
        await widget.isar.chatMessages.put(localMsg);
      });
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        _isManualJumping = false;
      });
    }
  }

  Future<ChatMessage> _insertOptimisticMessage(String content, bool isImage) async {
    final tempId = "temp_${DateTime.now().microsecondsSinceEpoch}";
    final msg = ChatMessage()
      ..remoteId = tempId
      ..content = content
      ..username = _username
      ..userId = _userId
      ..petId = _avatarIndex
      ..isImage = isImage
      ..channelName = _currentChannelName
      ..remoteChannelKey = "${tempId}_$_currentChannelName"
      ..createdAt = DateTime.now()
      ..status = 1
      ..replyToData = _replyingTo != null ? jsonEncode(_replyingTo) : null;

    await widget.isar.writeTxn(() async {
      await widget.isar.chatMessages.put(msg);
    });
    return msg;
  }

  void _jumpToMessage(List<ChatMessage> messages, String? replyToData) {
    if (replyToData == null) return;
    try {
      final replyTo = jsonDecode(replyToData);
      final String targetId = replyTo['id'].toString();
      int index = messages.indexWhere((m) => (m.remoteId ?? m.id.toString()) == targetId);
      
      if (index != -1) {
        setState(() {
          _highlightedMsgId = targetId;
        });

        _itemScrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
          alignment: 0.1,
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _highlightedMsgId = null);
        });
      }
    } catch (e) {
      debugPrint("跳转失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) async {
        setState(() => _isDragging = false);
        if (details.files.isNotEmpty) {
          final file = File(details.files.first.path);
          _uploadAndSendFile(file);
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Column(
              children: [
                _buildHeader(),
                const Divider(color: Colors.white10, height: 30),
                Expanded(
                  child: !_isInitialized 
                    ? const Center(child: Text("加载中...", style: TextStyle(color: Colors.white10))) 
                    : StreamBuilder<List<ChatMessage>>(
                        key: ValueKey(_currentChannelName),
                        stream: _isarMessageStream,
                        builder: (context, snapshot) {
                          final messages = snapshot.data ?? [];
                          return ScrollablePositionedList.builder(
                            itemScrollController: _itemScrollController,
                            itemPositionsListener: _itemPositionsListener,
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              return _buildChatBubble(
                                msg,
                                msg.userId == _userId,
                                () => _jumpToMessage(messages, msg.replyToData),
                              );
                            },
                          );
                        },
                      ),
                ),
                if (_replyingTo != null) _buildReplyPreview(),
                const SizedBox(height: 10),
                _buildInputArea(),
              ],
            ),
          ),
          if (_showScrollToBottomBtn)
            Positioned(
              bottom: (_replyingTo != null ? 140 : 90),
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => _scrollToBottom(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: _hasNewMessage ? Colors.redAccent : widget.accentColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _hasNewMessage ? Icons.mark_chat_unread_rounded : Icons.arrow_downward, 
                          size: 18, 
                          color: _hasNewMessage ? Colors.white : Colors.black
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _hasNewMessage ? "有新消息" : "回到最新位置",
                          style: TextStyle(
                            color: _hasNewMessage ? Colors.white : Colors.black, 
                            fontSize: 13, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_isDragging) _buildDragOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _showChannelPicker,
          child: Row(
            children: [
              Icon(Icons.hub_outlined, color: widget.accentColor, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ROCO HUB", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(_currentChannelName, style: TextStyle(color: widget.accentColor, fontSize: 10)),
                ],
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white24),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
                  const SizedBox(width: 6),
                  Text("$_onlineCount 在线", style: const TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.grey, size: 22),
              tooltip: "清空聊天记录",
              onPressed: _clearChatHistory,
            ),
            IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.grey, size: 22),
              onPressed: () => _showProfileDialog(),
            ),
          ],
        ),
      ],
    );
  }

  void _showChannelPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text("选择频道", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.public, color: widget.accentColor),
            title: const Text("基础频道", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              if (_currentChannelName != "基础频道") _switchChannel("基础频道");
            },
          ),
          ..._customChannels.map((ch) => ListTile(
            leading: const Icon(Icons.private_connectivity, color: Colors.blueAccent),
            title: Text(ch['name']!, style: const TextStyle(color: Colors.white)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white38, size: 18),
                  onPressed: () {
                    final code = _generateRoomCode(ch['name']!, ch['url']!, ch['key']!);
                    Clipboard.setData(ClipboardData(text: code)).then((_) {
                      Navigator.pop(context);
                      _showSuccessSnackBar("房间码已复制");
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                  onPressed: () => _deleteChannel(ch['name']!),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              if (_currentChannelName != ch['name']) _switchChannel(ch['name']!, url: ch['url'], key: ch['key']);
            },
          )),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.add_link, color: Colors.greenAccent),
            title: const Text("通过房间码加入", style: TextStyle(color: Colors.white70)),
            onTap: () { Navigator.pop(context); _showJoinByCodeDialog(); },
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.grey),
            title: const Text("创建自定义频道", style: TextStyle(color: Colors.grey)),
            onTap: () { Navigator.pop(context); _showCreateChannelDialog(); },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showJoinByCodeDialog() {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text("加入频道", style: TextStyle(color: Colors.white)),
        content: _buildDialogField(codeCtrl, "请粘贴房间码"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("取消")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.accentColor),
            onPressed: () {
              if (codeCtrl.text.isNotEmpty) { Navigator.pop(context); _joinChannelByCode(codeCtrl.text); }
            },
            child: const Text("加入", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showCreateChannelDialog() {
    final nameCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final keyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text("创建私人频道", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField(nameCtrl, "频道名称"),
            const SizedBox(height: 10),
            _buildDialogField(urlCtrl, "SUPABASE_URL"),
            const SizedBox(height: 10),
            _buildDialogField(keyCtrl, "SUPABASE_ANON_KEY"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("取消")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.accentColor),
            onPressed: () async {
              if (nameCtrl.text.isEmpty || urlCtrl.text.isEmpty || keyCtrl.text.isEmpty) return;
              final newChannel = {'name': nameCtrl.text, 'url': urlCtrl.text, 'key': keyCtrl.text};
              setState(() => _customChannels.add(newChannel));
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('custom_channels', jsonEncode(_customChannels));
              Navigator.pop(context);
              _switchChannel(newChannel['name']!, url: newChannel['url'], key: newChannel['key']);
            },
            child: const Text("创建", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  void _scrollToBottom({int? count}) {
    if (!_itemScrollController.isAttached) return;
    
    final targetIndex = (count ?? widget.isar.chatMessages
        .filter()
        .channelNameEqualTo(_currentChannelName)
        .countSync()) - 1;

    if (targetIndex < 0) return;

    _itemScrollController.scrollTo(
      index: targetIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    
    setState(() {
      _hasNewMessage = false;
      _isAtBottom = true; 
    });
  }

  void _clearReplyState() => setState(() => _replyingTo = null);
  void _showErrorSnackBar(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  
  Widget _buildInputArea() {
    return Row(
      children: [
        if (_canSendFile) IconButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null && result.files.single.path != null) {
              _uploadAndSendFile(File(result.files.single.path!));
            }
          },
          icon: const Icon(Icons.attach_file, color: Colors.grey),
        ),
        Expanded(
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: "聊点什么？",
              hintStyle: const TextStyle(color: Colors.white24),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            ),
            onSubmitted: (_) => _sendMessage(),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: _sendMessage,
          icon: const Icon(Icons.send_rounded),
          style: IconButton.styleFrom(
            backgroundColor: widget.accentColor,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(ChatMessage msg, bool isMe, VoidCallback onReplyTap) {
    int avatarIdx = msg.petId ?? 0;
    IconData avatarIcon = (avatarIdx < _avatars.length) ? _avatars[avatarIdx] : Icons.person;
    bool isImage = msg.isImage;
    var replyTo = msg.replyToData != null ? jsonDecode(msg.replyToData!) : null;
    String msgId = msg.remoteId ?? msg.id.toString();
    String timeStr = DateFormat('MM-dd HH:mm').format(msg.createdAt ?? DateTime.now());
    bool isHighlighted = _highlightedMsgId == msgId;

    return GestureDetector(
      onLongPress: () {
        setState(() => _replyingTo = {
          'id': msgId,
          'username': msg.username,
          'content': isImage ? "[图片]" : (msg.content?.startsWith('http') == true ? "[文件]" : msg.content),
        });
        _focusNode.requestFocus();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: isHighlighted ? widget.accentColor.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isMe) ...[
                    Text(timeStr, style: const TextStyle(color: Colors.white10, fontSize: 10)),
                    const SizedBox(width: 8),
                    Text(msg.username ?? "", style: TextStyle(color: widget.accentColor.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Icon(avatarIcon, size: 10, color: widget.accentColor.withOpacity(0.5)),
                  ] else ...[
                    Icon(avatarIcon, size: 10, color: Colors.white38),
                    const SizedBox(width: 4),
                    Text(msg.username ?? "", style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(timeStr, style: const TextStyle(color: Colors.white10, fontSize: 10)),
                  ],
                ],
              ),
            ),
            if (replyTo != null) GestureDetector(onTap: onReplyTap, child: _buildQuotedBox(replyTo)),
            _buildMessageBody(msg, isMe),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotedBox(dynamic replyTo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: widget.accentColor.withOpacity(0.5), width: 3)),
      ),
      child: Text("${replyTo['username']}: ${replyTo['content']}", style: const TextStyle(color: Colors.white38, fontSize: 11), maxLines: 1),
    );
  }

  Widget _buildMessageBody(ChatMessage msg, bool isMe) {
    final content = msg.content ?? "";
    final isUrl = content.startsWith('http');
    final msgId = msg.remoteId ?? msg.id.toString();

    final TextStyle messageTextStyle = TextStyle(
      color: isMe ? Colors.black : Colors.white,
      fontSize: 14, 
      fontWeight: FontWeight.w500,
      fontFamily: 'MIANFEIZITI', 
    );

    if (msg.isImage) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: isUrl ? _buildCachedImage(content) : Image.file(File(content), opacity: const AlwaysStoppedAnimation(0.5)),
      );
    }
    
    if (isUrl || (msg.status == 1 && _isFilePath(content))) {
      String fileName = "未知文件";
      try { fileName = isUrl ? Uri.decodeFull(p.basename(content)).split('_').last : p.basename(content); } catch (_) {}
      
      final progressNotifier = _downloadProgressMap.putIfAbsent(msgId, () => ValueNotifier<double?>(null));
      return Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: isMe ? widget.accentColor : const Color(0xFF3A3A3A), borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            Row(
              children: [
                Icon(_getFileIcon(fileName), color: isMe ? Colors.black : Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(fileName, style: messageTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1),
                      const SizedBox(height: 4),
                      ValueListenableBuilder<double?>(
                        valueListenable: progressNotifier,
                        builder: (context, progress, child) {
                          String label = msg.status == 1 ? "正在上传..." : "点击下载";
                          if (progress == -1.0) label = "已存入下载目录";
                          else if (progress != null) label = "下载中 ${(progress * 100).toInt()}%";
                          return Text(label, style: TextStyle(color: isMe ? Colors.black45 : Colors.white38, fontSize: 10));
                        },
                      ),
                    ],
                  ),
                ),
                if (isUrl) ValueListenableBuilder<double?>(
                  valueListenable: progressNotifier,
                  builder: (context, progress, child) {
                    if (progress == -1.0) return IconButton(icon: Icon(Icons.folder_open, color: isMe ? Colors.black : widget.accentColor), onPressed: () => _openFileLocation(content));
                    return IconButton(icon: Icon(Icons.download, color: isMe ? Colors.black : widget.accentColor), onPressed: () => _handleDownload(content, msgId));
                  }
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Opacity(
      opacity: msg.status == 1 ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: isMe ? widget.accentColor : const Color(0xFF3A3A3A), borderRadius: BorderRadius.circular(18)),
        child: SelectableText(content, style: messageTextStyle),
      ),
    );
  }

  bool _isFilePath(String path) => path.contains(':\\') || path.contains('/') || File(path).existsSync();

  IconData _getFileIcon(String fileName) {
    final ext = p.extension(fileName).toLowerCase();
    if (ext == '.pdf') return Icons.picture_as_pdf;
    if (['.zip', '.rar', '.7z'].contains(ext)) return Icons.inventory_2;
    return Icons.insert_drive_file;
  }

  Widget _buildCachedImage(String url) {
    return FutureBuilder<File>(
      future: customCacheManager.getSingleFile(url),
      builder: (context, snapshot) {
        if (snapshot.hasData) return Image.file(snapshot.data!, fit: BoxFit.cover);
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black26, border: Border(left: BorderSide(color: widget.accentColor, width: 4))),
      child: Row(
        children: [
          Expanded(child: Text("回复 @${_replyingTo!['username']}: ${_replyingTo!['content']}", style: const TextStyle(color: Colors.white60, fontSize: 12))),
          IconButton(icon: const Icon(Icons.close, size: 16), onPressed: _clearReplyState),
        ],
      ),
    );
  }

  Widget _buildDragOverlay() => Container(color: widget.accentColor.withOpacity(0.8), child: const Center(child: Icon(Icons.cloud_upload, size: 80)));

  void _showProfileDialog({bool isFirstTime = false}) {
    final nameController = TextEditingController(text: _username);
    int tempAvatarIndex = _avatarIndex;
    showDialog(
      context: context,
      barrierDismissible: !isFirstTime,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2D2D2D),
          title: Text(isFirstTime ? "初始档案" : "修改资料"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 10,
                children: List.generate(_avatars.length, (index) => GestureDetector(
                  onTap: () => setDialogState(() => tempAvatarIndex = index),
                  child: CircleAvatar(backgroundColor: tempAvatarIndex == index ? widget.accentColor : Colors.white10, child: Icon(_avatars[index])),
                )),
              ),
              const SizedBox(height: 20),
              TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "输入昵称")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('username', nameController.text);
                await prefs.setInt('avatarIndex', tempAvatarIndex);
                setState(() { _username = nameController.text; _avatarIndex = tempAvatarIndex; });
                if (_presenceChannel != null) await _presenceChannel?.track({'user_id': _userId, 'username': _username});
                Navigator.pop(context);
              },
              child: const Text("确定"),
            ),
          ],
        ),
      ),
    );
  }
}