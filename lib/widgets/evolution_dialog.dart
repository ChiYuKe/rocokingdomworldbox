import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/pet_model.dart';
import '../models/pet_evolution.dart';

/// 进化节点强类型定义
class EvolutionNode {
  final int id;
  final String name; // 名称字段
  final String portraitRes;
  final String iconRes;

  const EvolutionNode({
    required this.id,
    required this.name,
    required this.portraitRes,
    required this.iconRes,
  });
}

class EvolutionDialog extends StatefulWidget {
  final PetModel petModel;

  const EvolutionDialog({super.key, required this.petModel});

  @override
  State<EvolutionDialog> createState() => _EvolutionDialogState();
}

class _EvolutionDialogState extends State<EvolutionDialog> {
  List<EvolutionNode> _evolutionChain = [];
  EvolutionNode? _currentNode;
  
  bool _isHoveringShiny = false;
  bool _isLockedShiny = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  /// 多分支的进化数据初始化
  Future<void> _initData() async {
    try {
      final isar = Isar.getInstance();
      if (isar == null) return;

      // 收集所有可能的进化 ID
      final List<int> allChainPetIds = [];
      
      // 如果 petEvolutionId 为空，则仅展示自己
      if (widget.petModel.petEvolutionId.isEmpty) {
        allChainPetIds.add(widget.petModel.id);
      } else {
        // 遍历所有的进化 ID（处理多分支）
        for (final evoId in widget.petModel.petEvolutionId) {
          final evoData = await isar.petEvolutions.filter().idEqualTo(evoId).findFirst();
          if (evoData?.evolutionChain != null) {
            for (final node in evoData!.evolutionChain!) {
              if (node.petbaseId != null && !allChainPetIds.contains(node.petbaseId)) {
                allChainPetIds.add(node.petbaseId!);
              }
            }
          }
        }
      }

      // 批量转换为 EvolutionNode 强类型对象
      final List<EvolutionNode> nodes = [];
      for (final id in allChainPetIds) {
        final model = await isar.petModels.filter().idEqualTo(id).findFirst();
        if (model != null) {
          nodes.add(EvolutionNode(
            id: model.id,
            name: model.name, 
            portraitRes: model.jlRes,
            iconRes: model.jlSmallRes,
          ));
        }
      }

      if (mounted) {
        setState(() {
          _evolutionChain = nodes;
          _currentNode = nodes.firstWhere(
            (n) => n.id == widget.petModel.id,
            orElse: () => nodes.first,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("加载多分支进化链失败: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// 路径逻辑封装
  String get _displayImagePath {
    if (_currentNode == null) return "";
    final path = _currentNode!.portraitRes;
    return (_isHoveringShiny || _isLockedShiny) 
        ? path.replaceAll('.png', '_yise.png') 
        : path;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final themeColor = widget.petModel.types[0].themeColor;

    return Center(
      child: Container(
        width: 900,
        height: 520,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 50, spreadRadius: 10)
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              _buildLeftPanel(themeColor),
              _buildRightPanel(themeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPanel(Color themeColor) {
    return Expanded(
      flex: 6,
      child: Container(
        color: const Color(0xFF151515),
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(themeColor),
            const Spacer(),
            Center(
              child: _buildEvoTree(_evolutionChain, themeColor),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// 标题构建
  Widget _buildTitle(Color themeColor) {
    return Row(
      children: [
        Icon(Icons.hub_outlined, color: themeColor, size: 28),
        const SizedBox(width: 12),
        Text(
          "${_currentNode?.name ?? ""} 进化链",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel(Color themeColor) {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          border: Border(left: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: Stack(
          children: [
            _buildBackgroundId(),
            _buildPortrait(themeColor),
            Positioned(bottom: 30, right: 30, child: _buildShinyButton(themeColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundId() {
    return Positioned(
      bottom: -20,
      right: -10,
      child: Text(
        _currentNode?.id.toString() ?? "",
        style: TextStyle(
          color: Colors.white.withOpacity(0.02),
          fontSize: 180,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildPortrait(Color themeColor) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: const InstantOutCurve(),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(anim),
            child: child,
          ),
        ),
        child: Image.asset(
          _displayImagePath,
          key: ValueKey(_displayImagePath),
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.broken_image,
            size: 120,
            color: themeColor.withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  Widget _buildEvoTree(List<EvolutionNode> chain, Color themeColor) {
    if (chain.length >= 4) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildEvoNode(chain[0], themeColor),
          _buildEvoLine(),
          _buildEvoNode(chain[1], themeColor),
          _buildBranchPainter(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEvoNode(chain[2], themeColor),
              const SizedBox(height: 30),
              _buildEvoNode(chain[3], themeColor),
            ],
          )
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(chain.length, (i) => Row(
        children: [
          _buildEvoNode(chain[i], themeColor),
          if (i < chain.length - 1) _buildEvoLine(),
        ],
      )),
    );
  }

  Widget _buildEvoNode(EvolutionNode node, Color themeColor) {
    final bool isSelected = _currentNode?.id == node.id;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _currentNode = node),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? themeColor.withOpacity(0.15) : Colors.black,
              border: Border.all(
                color: isSelected ? themeColor : Colors.white12, 
                width: isSelected ? 2.5 : 1.5
              ),
              boxShadow: isSelected 
                  ? [BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)] 
                  : [],
            ),
            child: ClipOval(
              child: Image.asset(
                node.iconRes,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Colors.white10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "No.${node.id}",
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEvoLine() {
    return Container(
      width: 30,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildBranchPainter() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: CustomPaint(
        size: Size(40, 110),
        painter: EvoBranchPainter(color: Colors.white24),
      ),
    );
  }

  Widget _buildShinyButton(Color themeColor) {
    final bool isActive = _isLockedShiny || _isHoveringShiny;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringShiny = true),
      onExit: (_) => setState(() => _isHoveringShiny = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _isLockedShiny = !_isLockedShiny),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? themeColor.withOpacity(0.2) : Colors.white.withOpacity(0.05),
            border: Border.all(color: isActive ? themeColor : Colors.white24, width: 1.5),
          ),
          child: Image.asset(
            'assets/ui/ui_shiny.png',
            width: 40,
            height: 40,
            errorBuilder: (_, __, ___) => Icon(
              Icons.auto_awesome,
              color: isActive ? themeColor : Colors.white54,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class EvoBranchPainter extends CustomPainter {
  final Color color;
  const EvoBranchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.cubicTo(size.width * 0.5, size.height * 0.5, size.width * 0.5, 0, size.width, 0);
    path.moveTo(0, size.height / 2);
    path.cubicTo(size.width * 0.5, size.height * 0.5, size.width * 0.5, size.height, size.width, size.height);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant EvoBranchPainter oldDelegate) => oldDelegate.color != color;
}

class InstantOutCurve extends Curve {
  const InstantOutCurve();
  @override
  double transformInternal(double t) => 0.0;
}