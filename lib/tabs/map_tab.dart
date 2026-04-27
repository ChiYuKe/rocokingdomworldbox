import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/plugin_interface.dart';

class EternalPoint {
  final double x;
  final double y;
  const EternalPoint(this.x, this.y);

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
  factory EternalPoint.fromJson(Map<String, dynamic> json) => 
      EternalPoint(json['x'].toDouble(), json['y'].toDouble());
}

class MapMarker {
  final String title;
  final EternalPoint position;
  final int level; 
  final int iconCode;
  final int colorValue;

  MapMarker({
    required this.title, 
    required this.position, 
    required this.level,
    required this.iconCode, 
    required this.colorValue
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'position': position.toJson(),
    'level': level,
    'iconCode': iconCode,
    'colorValue': colorValue,
  };

  factory MapMarker.fromJson(Map<String, dynamic> json) => MapMarker(
    title: json['title'],
    position: EternalPoint.fromJson(json['position']),
    level: json['level'] ?? 0,
    iconCode: json['iconCode'],
    colorValue: json['colorValue'],
  );
}

class MapTab extends StatefulWidget {
  final List<RocoPlugin> plugins;
  final Color accentColor;

  const MapTab({super.key, required this.plugins, required this.accentColor});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final TransformationController _controller = TransformationController();
  int _currentLevel = 0;
  bool _isEditMode = false;

  final Map<int, Map<String, String>> multiLevelMapTiles = {
    0: {
      "0,0": "assets/Icon/map/01.png", "1,0": "assets/Icon/map/02.png","2,0": "assets/Icon/map/03.png", "3,0": "assets/Icon/map/04.png",  
      "0,1": "assets/Icon/map/05.png", "1,1": "assets/Icon/map/06.png","2,1": "assets/Icon/map/07.png", "3,1": "assets/Icon/map/08.png",
      "0,2": "assets/Icon/map/09.png", "1,2": "assets/Icon/map/10.png","2,2": "assets/Icon/map/11.png", "3,2": "assets/Icon/map/12.png",
      "0,3": "assets/Icon/map/13.png", "1,3": "assets/Icon/map/14.png","2,3": "assets/Icon/map/15.png", "3,3": "assets/Icon/map/16.png",
    },
    -1: {
      "2,2": "assets/Icon/map/A2_08_Assets_Humanities_06_LM.png", 
    },
  };

  List<MapMarker> markers = [];
  final double tileSize = 256.0;

  @override
  void initState() {
    super.initState();
    markers.add(MapMarker(
      title: "地面入口", 
      position: const EternalPoint(0.5, 0.5), 
      level: 0,
      iconCode: Icons.home.codePoint, 
      colorValue: Colors.green.value
    ));
  }

  // 计算全局边界以统一画布大小
  Rect _calculateGlobalBounds() {
    int minX = 0, maxX = 0, minY = 0, maxY = 0;
    bool first = true;
    for (var tiles in multiLevelMapTiles.values) {
      for (var key in tiles.keys) {
        var coords = key.split(',').map(int.parse).toList();
        if (first) {
          minX = maxX = coords[0];
          minY = maxY = coords[1];
          first = false;
        } else {
          if (coords[0] < minX) minX = coords[0];
          if (coords[0] > maxX) maxX = coords[0];
          if (coords[1] < minY) minY = coords[1];
          if (coords[1] > maxY) maxY = coords[1];
        }
      }
    }
    return Rect.fromLTRB(minX.toDouble(), minY.toDouble(), maxX.toDouble(), maxY.toDouble());
  }

  void _exportData() {
    final String jsonString = jsonEncode({
      "version": "1.2",
      "markers": markers.map((m) => m.toJson()).toList(),
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("复制标记 JSON"),
        content: SelectableText(jsonString),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("确定"))],
      ),
    );
  }

  void _handleMapTap(TapDownDetails details, Rect bounds) {
    if (!_isEditMode) return;
    final Offset localOffset = _controller.toScene(details.localPosition);
    
    setState(() {
      markers.add(MapMarker(
        title: "新标记 ${markers.length + 1}",
        position: EternalPoint(
          (localOffset.dx / tileSize) + bounds.left, 
          (localOffset.dy / tileSize) + bounds.top
        ),
        level: _currentLevel,
        iconCode: Icons.location_on.codePoint,
        colorValue: widget.accentColor.value,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalBounds = _calculateGlobalBounds();
    double canvasWidth = (globalBounds.width + 1) * tileSize;
    double canvasHeight = (globalBounds.height + 1) * tileSize;

    // 获取所有层级并从底向上排序
    List<int> sortedLevels = multiLevelMapTiles.keys.toList()..sort();

    return Row(
      children: [
        _buildSidePanel(),
        Expanded(
          child: Container(
            color: Colors.black, // 基础底色变暗
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRect(
                    child: GestureDetector(
                      onTapDown: (details) => _handleMapTap(details, globalBounds),
                      child: InteractiveViewer(
                        transformationController: _controller,
                        constrained: false,
                        minScale: 0.1,
                        maxScale: 5.0,
                        child: SizedBox(
                          width: canvasWidth,
                          height: canvasHeight,
                          child: Stack(
                            children: sortedLevels.map((level) {
                              bool isCurrent = level == _currentLevel;
                              return _buildLevelLayer(level, isCurrent, globalBounds);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(right: 20, bottom: 20, child: _buildLevelSelector()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelLayer(int level, bool isCurrent, Rect bounds) {
    final tiles = multiLevelMapTiles[level] ?? {};
    
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isCurrent ? 1.0 : 0.3, // 非当前层级半透明
      child: Stack(
        children: [
          // 渲染该层地块
          ...tiles.entries.map((entry) {
            var coords = entry.key.split(',').map(int.parse).toList();
            return Positioned(
              left: (coords[0] - bounds.left) * tileSize,
              top: (coords[1] - bounds.top) * tileSize,
              width: tileSize, height: tileSize,
              child: ColorFiltered(
                // 非当前层级应用变暗滤镜
                colorFilter: ColorFilter.mode(
                  isCurrent ? Colors.transparent : Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
                child: Image.asset(entry.value, fit: BoxFit.fill),
              ),
            );
          }),
          // 渲染该层标点
          ...markers.where((m) => m.level == level).map((m) => Positioned(
            left: (m.position.x - bounds.left) * tileSize,
            top: (m.position.y - bounds.top) * tileSize,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -1.0),
              child: Icon(
                IconData(m.iconCode, fontFamily: 'MaterialIcons'),
                color: Color(m.colorValue).withOpacity(isCurrent ? 1.0 : 0.4),
                size: 32,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLevelSelector() {
    List<int> levels = multiLevelMapTiles.keys.toList()..sort((a, b) => b.compareTo(a));
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: levels.map((l) => GestureDetector(
          onTap: () => setState(() => _currentLevel = l),
          child: Container(
            width: 50, height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _currentLevel == l ? widget.accentColor.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              l == 0 ? "1F" : (l < 0 ? "B${l.abs()}" : "${l + 1}F"),
              style: TextStyle(
                color: _currentLevel == l ? widget.accentColor : Colors.white60,
                fontWeight: _currentLevel == l ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildSidePanel() {
    return Container(
      width: 280,
      color: const Color(0xFF161616),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("多层叠加系统", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("当前聚焦: ${_currentLevel == 0 ? '地面' : '地下${_currentLevel.abs()}层'}", style: const TextStyle(color: Colors.white38)),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("打点模式", style: TextStyle(color: Colors.white70, fontSize: 14)),
            value: _isEditMode,
            onChanged: (v) => setState(() => _isEditMode = v),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _exportData,
            icon: const Icon(Icons.share, size: 18),
            label: const Text("导出 JSON"),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _controller.value = Matrix4.identity(),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
            child: const Text("视角复位"),
          ),
        ],
      ),
    );
  }
}