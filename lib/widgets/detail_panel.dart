import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/skill_model.dart';

import '../widgets/radar_chart.dart';
import 'package:isar/isar.dart';
import '../widgets/evolution_dialog.dart';



// 详情面板组件 
class DetailPanel extends StatefulWidget {
  final PetModel pet_model;
  final Color accentColor;
  final int lockedIndex; // 接收外部传入的锁定索引
  final ValueChanged<int> onLockedIndexChanged; // 状态回调

  const DetailPanel({
    super.key,
    required this.pet_model,
    required this.accentColor,
    required this.lockedIndex,
    required this.onLockedIndexChanged,
  });

  @override
  State<DetailPanel> createState() => _DetailPanelState();
}

class _DetailPanelState extends State<DetailPanel> {
  int? _hoverIndex;

  SkillModel? _abilityModel;

  @override
  void initState() {
    super.initState();
    _loadAbility();
  }

  @override
  void didUpdateWidget(DetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 关键逻辑：如果切换了宠物，或者该宠物的特性 ID 发生了变化，重新加载数据
    if (oldWidget.pet_model.id != widget.pet_model.id) {
      _loadAbility();
    }
  }

  /// 从 Isar 数据库加载特性信息
// 从 Isar 数据库加载特性信息
  Future<void> _loadAbility() async {
    final isar = Isar.getInstance();
    final int? aid = widget.pet_model.petFeature;
    if (isar != null && aid != null) {
      final ability = await isar.skillModels.where().idEqualTo(aid).findFirst();
      if (mounted) {
        setState(() {
          _abilityModel = ability;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _abilityModel = null;
        });
      }
    }
  }

  String _getPortraitPath(int index) {
    final String currentId = widget.pet_model.id.toString(); 
    if (index == 0) return widget.pet_model.jlRes; // 优先使用模型中的 jlRes 字段
    if (index == 1) return 'assets/portraits/${currentId}_s.png';

    String fileNamePart = currentId;
    if (widget.pet_model.evolutions.isNotEmpty) {
      fileNamePart = widget.pet_model.evolutions.last;
    }

    String suffix = (index == 2) ? "_e" : "_f";
    return 'assets/ef/pet_$fileNamePart$suffix.png';
  }

  @override
  Widget build(BuildContext context) {
    int activeIndex = _hoverIndex ?? widget.lockedIndex;
    String currentPath = _getPortraitPath(activeIndex);

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Color(0xFF2D2D2D),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(80),
              bottomLeft: Radius.circular(80),
              topRight: Radius.circular(35),
              bottomRight: Radius.circular(35))),
      child: Column(
        children: [
          const SizedBox(height: 30),

          // 立绘展示区
          Expanded(
            flex: 3,
            child: RepaintBoundary(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: Transform.translate(
                  key: ValueKey(currentPath), 
                  offset: const Offset(0, 20), // x为0，y为20（正数向下，负数向上）
                  child: Transform.scale(
                    scale: 1.5,
                    child: Image.asset(
                      currentPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, _, __) => Icon(
                        Icons.catching_pokemon,
                        size: 140,
                        color: widget.accentColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 信息详情区
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopHeader(),
                  Text("系列：${widget.pet_model.types[0].label} | 编号：No.${widget.pet_model.pictorialBookId}",
                      style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white10, thickness: 1)),
                  
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 左侧：雷达图
                      Expanded(
                        flex: 4,
                        child: Center( // 增加 Center 确保在容器内居中
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: StatRadarChart(
                                stats: widget.pet_model.stats,
                                color: widget.accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                        
                        const SizedBox(width: 30),

                        // 右侧：特性 + 数值条
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAbilitySection(),
                              
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Divider(
                                  color: widget.accentColor.withOpacity(0.3),
                                  thickness: 1.5,
                                ),
                              ),

                              _buildStatsGrid(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 底部操作栏
          Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionBtn(label: "技能详情", icon: Icons.bolt, color: widget.accentColor, onTap: () {}),
                    const SizedBox(width: 20),
                    _buildActionBtn(label: "进化链", icon: Icons.history, color: widget.accentColor, onTap: () => _showEvolutionWindow(context)),
                  ])),
        ],
      ),
    );
  }

  // 内部辅助构建方法
  Widget _buildTopHeader() {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(widget.pet_model.name,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold)),
      const SizedBox(width: 5),
      _buildTypeIcons(),
      const Spacer(),
      Row(
        children: [
          _buildExtraTag(0, 'assets/ui/ui_pet.png'),
          _buildExtraTag(1, 'assets/ui/ui_shiny.png'),
          _buildExtraTag(2, 'assets/ui/ui_egg.png'),
          _buildExtraTag(3, 'assets/ui/ui_fruit.png'),
        ],
      ),
    ]);
  }

  Widget _buildAbilitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("特", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
              Text("性", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 15),
          Container(
            width: 38,
            height: 38,
            clipBehavior: Clip.antiAlias, 
            decoration: BoxDecoration(
              color: widget.accentColor.withOpacity(0.1),
              shape: BoxShape.rectangle, 
              borderRadius: BorderRadius.circular(8), 
            ),
            child: Center(
              child: _abilityModel != null
                  ? Image.asset(
                      _abilityModel!.icon,
                      // 关键点 3：建议图片宽高与容器一致或自适应
                      width: 38, 
                      height: 38,
                      fit: BoxFit.cover, 
                      errorBuilder: (context, _, __) => Icon(
                        Icons.auto_awesome,
                        color: widget.accentColor,
                        size: 18,
                      ),
                    )
                  : Icon(
                      Icons.hourglass_empty,
                      color: widget.accentColor,
                      size: 18,
                    ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _abilityModel?.name ?? "读取中...", 
                  style: TextStyle(color: widget.accentColor, fontSize: 16, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  _abilityModel?.desc ?? "正在努力寻找特性的力量...",
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Wrap(
      runSpacing: 18,
      spacing: 20,
      children: [
        _buildAnimatedStat(label: "生命", value: widget.pet_model.stats[0], color: widget.accentColor),
        _buildAnimatedStat(label: "物攻", value: widget.pet_model.stats[1], color: widget.accentColor),
        _buildAnimatedStat(label: "魔攻", value: widget.pet_model.stats[2], color: widget.accentColor),
        _buildAnimatedStat(label: "物防", value: widget.pet_model.stats[3], color: widget.accentColor),
        _buildAnimatedStat(label: "魔防", value: widget.pet_model.stats[4], color: widget.accentColor),
        _buildAnimatedStat(label: "速度", value: widget.pet_model.stats[5], color: widget.accentColor),
      ],
    );
  }





  // 辅助 UI 方法
  Widget _buildTypeIcons() {
    return Row(
      children: widget.pet_model.types.map((type) => Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Image.asset(
          'assets/ui/types/type_${type.name}.png',
          width: 35, height: 35,
          
          errorBuilder: (context, _, __) => Container(
              width: 30, height: 30,
              decoration: BoxDecoration(color: type.themeColor, shape: BoxShape.circle)),
        ),
      )).toList(),
    );
  }

  Widget _buildExtraTag(int index, String assetPath) {
    // 使用外部传入的 widget.lockedIndex 判断激活状态
    final bool isActive = (_hoverIndex ?? widget.lockedIndex) == index;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverIndex = index),
      onExit: (_) => setState(() => _hoverIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onLockedIndexChanged(index), // 调用回调更新父组件状态
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36, height: 36, padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: isActive ? widget.accentColor.withOpacity(0.2) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: isActive ? widget.accentColor : Colors.white10, width: 1.5),
            ),
            child: Image.asset(assetPath, fit: BoxFit.contain, color: isActive ? null : Colors.white38),
          ),
        ),
      ),
    );
  }


  // 进化链窗口
  void _showEvolutionWindow(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Evolution",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => EvolutionDialog(
        petModel: widget.pet_model,
      ),
    );
  }



  /// 构建带动画的能力值显示组件，包含标签、数值和进度条
  Widget _buildAnimatedStat({
    required String label,
    required int value,
    required Color color,
    double maxValue = 350.0, 
  }) {
    // 预计算进度比例，增加安全性检查
    final double progress = (value / maxValue).clamp(0.0, 1.0);

    return SizedBox(
      width: 145,
      child: Column(
        mainAxisSize: MainAxisSize.min, // 使 Column 占用最小垂直空间
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部文字行
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const Spacer(), // 使用 Spacer 替代 MainAxisAlignment.spaceBetween，布局更稳固
              Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()], //等宽数字，防止动画时文字抖动
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // 动画进度条
          SizedBox(
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                // 使用 child 参数防止 LinearProgressIndicator 意外重建
                builder: (context, animValue, _) {
                  return LinearProgressIndicator(
                    value: animValue,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    color: color,
                    minHeight: 6,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部操作按钮，支持禁用状态显示
  Widget _buildActionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return TextButton( // 使用 TextButton 显得更轻量
      onPressed: onTap,
      style: TextButton.styleFrom(
        // 只在文字和图标上使用颜色，背景保持极其清淡
        foregroundColor: color,
        backgroundColor: color.withOpacity(0.08), 
        minimumSize: const Size(120, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // 稍微硬朗一点的圆角
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18), // 稍微缩小图标
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500, // 降低字重，更清爽
            ),
          ),
        ],
      ),
    );
  }


}


/// 一个在指定点立即跳转的曲线，用于取消 AnimatedSwitcher 的插值感
class InstantOutCurve extends Curve {
  @override
  double transformInternal(double t) => 0.0; // 无论动画进行到哪，输出始终为0（消失）
}
