import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/pet.dart';

class SettingsTab extends StatefulWidget {
  final Color accentColor;
  
  //接收父组件的状态
  final bool isColorLocked;
  final PetType selectedType;
  final double colorIntensity;
  final ValueChanged<bool> onLockChanged;
  final ValueChanged<PetType> onTypeChanged;
  final ValueChanged<double> onIntensityChanged;

  const SettingsTab({
    super.key, 
    required this.accentColor,
    required this.isColorLocked,
    required this.selectedType,
    required this.colorIntensity,
    required this.onLockChanged,
    required this.onTypeChanged,
    required this.onIntensityChanged,
  });

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  int _activeCategory = 0;
  
  // 常规设置状态
  bool _hdPortrait = true;
  double _uiScale = 1.0;

  // 音效设置状态
  bool _masterSound = true;
  double _bgmVolume = 0.5;

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

  //常规设置面板
  Widget _buildGeneralSettings() => Padding(
    key: const ValueKey(0),
    padding: const EdgeInsets.all(40),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("显示选项"),
          _buildSwitchTile("高清立绘加载", "开启后将展示精细度更高的精灵原画(真的假的？)", _hdPortrait, (v) => setState(() => _hdPortrait = v)),
          const SizedBox(height: 30),
          _buildSliderTile("不知道干嘛的", _uiScale, 0.5, 1.5, (v) => setState(() => _uiScale = v)),
          
          const Divider(color: Colors.white10, height: 60),
          
          _buildSectionHeader("个性化配色"),
          // 使用父组件传进来的 widget.isColorLocked 和 widget.onLockChanged
          _buildSwitchTile(
            "锁定当前色系", 
            "锁定后背景颜色将不再随精灵选中而变化", 
            widget.isColorLocked, 
            widget.onLockChanged
          ),
          const SizedBox(height: 24),
          Opacity(
            opacity: widget.isColorLocked ? 1.0 : 0.4,
            child: IgnorePointer(
              ignoring: !widget.isColorLocked,
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
                      value: widget.selectedType, // 使用父组件传进来的值
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
                        if (newValue != null) widget.onTypeChanged(newValue);
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
              widget.colorIntensity, 
              0.0, 1, 
              widget.onIntensityChanged
            ),

        ],
      ),
    ),
  );


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
        const Text(
          "ChiYuKe的个人UI练习", 
          textAlign: TextAlign.center, 
          style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)
        ),
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