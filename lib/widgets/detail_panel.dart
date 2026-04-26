import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/radar_chart.dart';
import 'package:isar/isar.dart';
import 'dart:math' as math;



// 详情面板组件 
class DetailPanel extends StatefulWidget {
  final Pet pet;
  final Color accentColor;
  final int lockedIndex; // 接收外部传入的锁定索引
  final ValueChanged<int> onLockedIndexChanged; // 状态回调

  const DetailPanel({
    super.key,
    required this.pet,
    required this.accentColor,
    required this.lockedIndex,
    required this.onLockedIndexChanged,
  });

  @override
  State<DetailPanel> createState() => _DetailPanelState();
}

class _DetailPanelState extends State<DetailPanel> {
  int? _hoverIndex;
  
  // 用于存储从数据库异步加载的特性对象
  Ability? _currentAbility;
  
  // 静态内存缓存，防止在同一个 session 中重复查询相同的特性 ID
  static final Map<String, Ability> _abilityCache = {};

  @override
  void initState() {
    super.initState();
    _loadAbility();
  }

  @override
  void didUpdateWidget(DetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 关键逻辑：如果切换了宠物，或者该宠物的特性 ID 发生了变化，重新加载数据
    if (oldWidget.pet.id != widget.pet.id) {
      _loadAbility();
    }
  }

  /// 从 Isar 数据库加载特性信息
  Future<void> _loadAbility() async {
    final String? aid = widget.pet.abilityId; // 假设你的 Pet 模型中有这个字段

    if (aid == null || aid.isEmpty) {
      if (mounted) setState(() => _currentAbility = null);
      return;
    }

    // 1. 检查缓存
    if (_abilityCache.containsKey(aid)) {
      if (mounted) setState(() => _currentAbility = _abilityCache[aid]);
      return;
    }

    // 2. 异步查询数据库
    final isar = Isar.getInstance();
    if (isar != null) {
      // 假设你的 Ability 集合中 aid 是索引字段
      final ability = await isar.abilitys.filter().aidEqualTo(aid).findFirst();
      if (ability != null) {
        _abilityCache[aid] = ability;
        if (mounted) setState(() => _currentAbility = ability);
      }
    }
  }

  String _getPortraitPath(int index) {
    final String currentId = widget.pet.petId;
    if (index == 0) return 'assets/portraits/pet_$currentId.png';
    if (index == 1) return 'assets/portraits/pet_${currentId}_s.png';

    String fileNamePart = currentId;
    if (widget.pet.evolutions.isNotEmpty) {
      fileNamePart = widget.pet.evolutions.last;
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
                child: Image.asset(
                  currentPath,
                  key: ValueKey(currentPath),
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
          // 信息详情区
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopHeader(),
                  Text("系列：${widget.pet.types[0].label} | 编号：No.${widget.pet.petId}",
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
                                stats: widget.pet.stats,
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
      Text(widget.pet.name,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold)),
      const SizedBox(width: 12),
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
            decoration: BoxDecoration(
              color: widget.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: _currentAbility != null
                ? Image.asset(
                    'assets/abilitys/${_currentAbility!.image}', // 使用数据库中的图片路径
                    width: 40,
                    height: 40,
                    errorBuilder: (context, _, __) => Icon(Icons.auto_awesome, color: widget.accentColor, size: 18),
                  )
                : Icon(Icons.hourglass_empty, color: widget.accentColor, size: 18),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentAbility?.name ?? "读取中...", 
                  style: TextStyle(color: widget.accentColor, fontSize: 16, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentAbility?.description ?? "正在努力寻找特性的力量...",
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
        _buildAnimatedStat(label: "生命", value: widget.pet.stats[0], color: widget.accentColor),
        _buildAnimatedStat(label: "物攻", value: widget.pet.stats[1], color: widget.accentColor),
        _buildAnimatedStat(label: "魔攻", value: widget.pet.stats[2], color: widget.accentColor),
        _buildAnimatedStat(label: "物防", value: widget.pet.stats[3], color: widget.accentColor),
        _buildAnimatedStat(label: "魔防", value: widget.pet.stats[4], color: widget.accentColor),
        _buildAnimatedStat(label: "速度", value: widget.pet.stats[5], color: widget.accentColor),
      ],
    );
  }





  // 辅助 UI 方法
  Widget _buildTypeIcons() {
    return Row(
      children: widget.pet.types.map((type) => Padding(
        padding: const EdgeInsets.only(right: 6),
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
    String currentId = widget.pet.petId;
    
    // --- 状态变量定义在 StatefulBuilder 外部，通过闭包实现状态持久化 ---
    bool isHoveringShiny = false; // 鼠标悬停预览状态
    bool isLockedShiny = false;   // 点击锁定异色状态

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Evolution",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => Center(
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            // 计算最终是否显示异色：悬停或锁定任意一个为真即可
            final bool showShiny = isHoveringShiny || isLockedShiny;

            return Container(
              width: 900,
              height: 520,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 50,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    // 左边：进化分支链
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: const Color(0xFF151515),
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.hub_outlined, color: widget.pet.types[0].themeColor, size: 28),
                                const SizedBox(width: 12),
                                const Text("进化链",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2)),
                              ],
                            ),
                            const Spacer(),
                            Center(
                              child: _buildEvoTree(widget.pet.evolutions, currentId, (newId) {
                                // 切换宠物时，建议重置异色状态，或者根据需要保留
                                setDialogState(() => currentId = newId);
                              }),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    // 右边：立绘展示
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF222222),
                          border: Border(left: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
                        ),
                        child: Stack(
                          children: [
                            // 背景大数字 ID
                            Positioned(
                              bottom: -20,
                              right: -10,
                              child: Text(currentId,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.02),
                                      fontSize: 180,
                                      fontWeight: FontWeight.w900)),
                            ),


                            // 主立绘切换动画
                            Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                switchInCurve: Curves.easeOutBack,
                                switchOutCurve: InstantOutCurve(), 
                                
                               
                                layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                                  return currentChild ?? const SizedBox.shrink();
                                },
                                // ------------------------------------------------------------

                                transitionBuilder: (child, anim) {
                                  // 只有当前正在进入的 child (新ID) 才会显示并缩放
                                  return FadeTransition(
                                    opacity: anim,
                                    child: ScaleTransition(
                                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(anim),
                                      child: child,
                                    ),
                                  );
                                },
                                child: AnimatedSwitcher(
                                  key: ValueKey("evolution_group_$currentId"),
                                  duration: const Duration(milliseconds: 400),
                                  layoutBuilder: (currentChild, previousChildren) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [...previousChildren, if (currentChild != null) currentChild],
                                    );
                                  },
                                  transitionBuilder: (innerChild, innerAnim) => FadeTransition(opacity: innerAnim, child: innerChild),
                                  child: Image.asset(
                                    'assets/portraits/pet_$currentId${showShiny ? "_s" : ""}.png',
                                    key: ValueKey("portrait_${currentId}_$showShiny"),
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => Icon(Icons.broken_image, size: 120, color: widget.pet.types[0].themeColor.withOpacity(0.1)),
                                  ),
                                ),
                              ),
                            ),


                            // 右下角异色切换 UI
                            Positioned(
                              bottom: 30,
                              right: 30,
                              child: MouseRegion(
                                onEnter: (_) => setDialogState(() => isHoveringShiny = true),
                                onExit: (_) => setDialogState(() => isHoveringShiny = false),
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => setDialogState(() => isLockedShiny = !isLockedShiny),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // 悬停或锁定都会让背景变亮
                                      color: (isLockedShiny || isHoveringShiny)
                                          ? widget.pet.types[0].themeColor.withOpacity(0.2) // 悬停时稍微亮一点
                                          : Colors.white.withOpacity(0.05),
                                      
                                      // 悬停或锁定都会改变边框颜色 
                                      border: Border.all(
                                        color: (isLockedShiny || isHoveringShiny) 
                                            ? widget.pet.types[0].themeColor 
                                            : Colors.white24,
                                        width: 1.5,
                                      ),

                                      // 悬停或锁定都会产生外发光
                                      boxShadow: (isLockedShiny || isHoveringShiny)
                                          ? [
                                              BoxShadow(
                                                color: widget.pet.types[0].themeColor.withOpacity(0.3),
                                                blurRadius: 15, // 增加模糊半径，发光感更强
                                                spreadRadius: 2,
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Image.asset(
                                      'assets/ui/ui_shiny.png',
                                      width: 40,
                                      height: 40,
                                      // 这里的图标颜色也可以根据状态微调
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        (isLockedShiny || isHoveringShiny) 
                                            ? Icons.auto_awesome 
                                            : Icons.auto_awesome_outlined,
                                        color: (isLockedShiny || isHoveringShiny) 
                                            ? widget.pet.types[0].themeColor 
                                            : Colors.white54,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }




  /// 构建进化链的核心组件，根据传入的 ID 列表动态生成节点和连接线，支持分叉进化
  Widget _buildEvoTree(List<String> ids, String currentId, Function(String) onSelect) {
  // final themeColor = pet.type.themeColor;

  if (ids.length >= 4) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        _buildEvoNode(ids[0], currentId == ids[0], () => onSelect(ids[0])),
        _buildEvoLine(),
        _buildEvoNode(ids[1], currentId == ids[1], () => onSelect(ids[1])),
        
        // 分叉连接线，使用 CustomPaint 绘制两条平行的贝塞尔曲线形成分叉效果
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.translate(
            // 这里向上偏移一个小数值,应该是底部文字和间距高度的一半
            offset: const Offset(0, -10), 
            child: CustomPaint(
              size: const Size(40, 110), 
              painter: EvoBranchPainter(color: Colors.white24),
            ),
          ),
        ),
        
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEvoNode(ids[2], currentId == ids[2], () => onSelect(ids[2])),
            const SizedBox(height: 30), 
            _buildEvoNode(ids[3], currentId == ids[3], () => onSelect(ids[3])),
          ],
        )
      ],
    );
  }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(ids.length, (i) => Row(children: [
        _buildEvoNode(ids[i], currentId == ids[i], () => onSelect(ids[i])),
        if (i < ids.length - 1) _buildEvoLine(),
      ])),
    );
  }
 
  /// 构建单个进化节点，包含点击事件和选中状态的视觉反馈
  Widget _buildEvoNode(String id, bool isSelected, VoidCallback onTap) {
    final themeColor = widget.pet.types[0].themeColor;
    
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 78, height: 78, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? themeColor.withOpacity(0.15) : Colors.black,
              border: Border.all(
                color: isSelected ? themeColor : Colors.white12, 
                width: isSelected ? 2.5 : 1.5
              ),
              boxShadow: isSelected ? [
                BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)
              ] : [],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/avatars/pet_$id.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(Icons.pets, color: Colors.white10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "No.$id", 
          style: TextStyle(
            // 未选中时使用 white54 确保在暗色背景下也能看清
            color: isSelected ? Colors.white : Colors.white54, 
            fontSize: 15, 
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          )
        ),
      ],
    );
  }

  /// 构建进化链连接线，使用简单的 Container 进行水平连接，并通过 Transform.translate 调整位置使其与节点更紧密连接
  Widget _buildEvoLine() {
    const double lineWidth = 5;// 线条宽度
    return Transform.translate(
      offset: const Offset(0, -10),// 向上偏移，使线条与节点更紧密连接
      child: Container(
        width: 30, 
        height: lineWidth,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(lineWidth / 3),
        ),
      ),
    );
  }



  /// 构建带动画的能力值显示组件，包含标签、数值和进度条
  Widget _buildAnimatedStat({
    required String label,
    required double value,
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


/// 进化分支连接线的自定义画笔，绘制两条平行的贝塞尔曲线形成分叉效果
class EvoBranchPainter extends CustomPainter {
  final Color color;
  EvoBranchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          color.withOpacity(0.5), 
          color.withOpacity(0.5), 
          color.withOpacity(0.5),],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double startY = size.height / 2;
    
    // 绘制上半部分曲线
    path.moveTo(0, startY);
    path.cubicTo(size.width * 0.5, startY, size.width * 0.5, 0, size.width, 0);
    
    // 绘制下半部分曲线
    path.moveTo(0, startY);
    path.cubicTo(size.width * 0.5, startY, size.width * 0.5, size.height, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// 一个在指定点立即跳转的曲线，用于取消 AnimatedSwitcher 的插值感
class InstantOutCurve extends Curve {
  @override
  double transformInternal(double t) => 0.0; // 无论动画进行到哪，输出始终为0（消失）
}
