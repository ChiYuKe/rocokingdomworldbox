import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/pet_model.dart';
import '../models/settingsprovider.dart';

class SettingsTab extends StatefulWidget {
  final Color accentColor;
  final SettingsProvider settings; // 接收 Provider

  const SettingsTab({
    super.key, 
    required this.accentColor,
    required this.settings,
  });

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  int _activeCategory = 0;
  bool _masterSound = true;
  double _bgmVolume = 0.5;

  // 恢复默认设置
  Future<void> _resetToDefault() async {
    final s = widget.settings;
    s.resetSettings();


    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("已恢复默认配置"), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _clearAllCache() async {
    try {
      await CacheManager(Config('RocoKingdomCache')).emptyCache();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("所有缓存与配置已清空，请重启应用"), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("清理失败: $e"), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
        borderRadius: BorderRadius.all(Radius.circular(35)),
      ),
      child: Row(
        children: [
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), bottomLeft: Radius.circular(35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("设置中心", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                _buildCategoryBtn(0, "常规设置", Icons.tune_rounded),
                _buildCategoryBtn(1, "音效控制", Icons.volume_up_rounded),
                _buildCategoryBtn(2, "关于图鉴", Icons.info_outline_rounded),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildRightPanelContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBtn(int index, String title, IconData icon) {
    final bool isSelected = _activeCategory == index;
    return GestureDetector(
      onTap: () => setState(() => _activeCategory = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? widget.accentColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? widget.accentColor : Colors.white38, size: 20),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white38, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanelContent() {
    switch (_activeCategory) {
      case 0: return _buildGeneralSettings();
      case 1: return _buildAudioSettings();
      case 2: return _buildAboutPanel();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildGeneralSettings() {
    final s = widget.settings; 
    
    return Padding(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("显示选项"),
            _buildSwitchTile("高清立绘加载", "开启后将展示精细度更高的精灵原画", s.hdPortrait, (v) => s.setHdPortrait(v)),
            
            const Divider(color: Colors.white10, height: 60),
            
            _buildSectionHeader("个性化配色"),
            _buildSwitchTile(
              "锁定当前色系", 
              "锁定后背景颜色将不再随精灵选中而变化", 
              s.isColorLocked, 
              (v) => s.setColorLocked(v) 
            ),
            const SizedBox(height: 24),
            Opacity(
              opacity: s.isColorLocked ? 1.0 : 0.4,
              child: IgnorePointer(
                ignoring: !s.isColorLocked,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("手动指定色系", style: TextStyle(color: Colors.white, fontSize: 18)),
                        Text("需开启上方锁定开关后生效", style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: DropdownButton<PetType>(
                        value: s.selectedType,
                        dropdownColor: const Color(0xFF2D2D2D),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: PetType.values.map((PetType type) {
                          return DropdownMenuItem<PetType>(
                            value: type,
                            child: Row(
                              children: [
                                Container(
                                  width: 12, height: 12,
                                  decoration: BoxDecoration(color: type.themeColor, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 10),
                                Text(type.label, style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (PetType? newValue) {
                          if (newValue != null) s.setSelectedType(newValue);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSliderTile(
                "背景色彩强度", 
                s.colorIntensity, 
                0.0, 1, 
                (v) => s.setColorIntensity(v)
              ),

            const Divider(color: Colors.white10, height: 60),

            _buildSectionHeader("存储与重置"),
            // 恢复默认按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("恢复默认设置", style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text("将所有开关、配色和调节项还原至初始状态", style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: _resetToDefault,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text("恢复默认"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // 清理缓存按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("清理所有缓存", style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text("包括图片缓存、本地消息记录及个人配置信息", style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF2D2D2D),
                        title: const Text("确认清理？", style: TextStyle(color: Colors.white)),
                        content: const Text("这将删除所有本地存储的数据且不可恢复。", style: TextStyle(color: Colors.white70)),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("取消")),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _clearAllCache();
                            },
                            child: const Text("确定清理", style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Colors.redAccent, width: 0.5),
                  ),
                  icon: const Icon(Icons.delete_sweep_rounded, size: 20),
                  label: const Text("立即清理"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioSettings() => Padding(
    key: const ValueKey(1),
    padding: const EdgeInsets.all(40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("音频管理"),
        _buildSwitchTile("主音量开关", "到时候做个音乐播放器，岂不是妙哉！", _masterSound, (v) => setState(() => _masterSound = v)),
        const Divider(color: Colors.white10, height: 40),
        _buildSliderTile("背景音乐 (BGM)", _bgmVolume, 0, 1, (v) => setState(() => _bgmVolume = v)),
      ],
    ),
  );

  Widget _buildAboutPanel() => Padding(
    key: const ValueKey(2),
    padding: const EdgeInsets.all(40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(shape: BoxShape.circle, color: widget.accentColor.withOpacity(0.1)),
          child: Icon(Icons.catching_pokemon, size: 80, color: widget.accentColor),
        ),
        const SizedBox(height: 20),
        const Text("洛克王国盒子", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const Text("Version 0.0.0 (beta version)", style: TextStyle(color: Colors.white38, fontSize: 14)),
        const SizedBox(height: 30),
        const Text("ChiYuKe的个人UI练习", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
        const Spacer(),
        const Text("© 2026 Roco Kingdom World.", style: TextStyle(color: Colors.white10, fontSize: 12)),
      ],
    ),
  );

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Text(title, style: TextStyle(color: widget.accentColor, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
  );

  Widget _buildSwitchTile(String t, String d, bool v, ValueChanged<bool> o) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t, style: const TextStyle(color: Colors.white, fontSize: 18)),
        Text(d, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ]),
      CupertinoSwitch(activeColor: widget.accentColor, value: v, onChanged: o),
    ],
  );

  Widget _buildSliderTile(String t, double v, double min, double max, ValueChanged<double> o) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text("${(v * 100).toInt()}%", style: TextStyle(color: widget.accentColor, fontWeight: FontWeight.bold)),
        ],
      ),
      Slider(activeColor: widget.accentColor, inactiveColor: Colors.white10, value: v, min: min, max: max, onChanged: o),
    ],
  );
}