import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final dynamic pet_model;
  final int index;
  final bool isSelected;
  final Function(int) onSelected;
  final int stackCount; // 叠加数量

  const PetCard({
    super.key,
    required this.pet_model,
    required this.index,
    required this.isSelected,
    required this.onSelected,
    this.stackCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 视觉叠加层
        if (stackCount > 1)
          Positioned(
            top: 5, left: 5, right: -5, bottom: -5,
            child: _buildBackDecoration(0.08),
          ),
        if (stackCount > 2)
          Positioned(
            top: 10, left: 10, right: -10, bottom: -10,
            child: _buildBackDecoration(0.04),
          ),

        // 主卡片
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2D2D2D) : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? Colors.white24 : Colors.transparent, width: 1),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 16),
                child: Column(
                  children: [
                    // 头像部分
                    Expanded(
                      child: Center(
                        child: Transform.scale(
                          scale: 1.3,
                          child: Image.asset(
                            'assets/Icon/BigHeadIcon256/${pet_model.id}.png',
                            fit: BoxFit.contain,
                            color: isSelected ? null : Colors.white.withOpacity(0.8),
                            colorBlendMode: isSelected ? null : BlendMode.modulate,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, color: Colors.white24, size: 24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 名称
                    Text(
                      pet_model.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    // 类型标签
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (pet_model.types as List).map<Widget>((type) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? type.themeColor.withOpacity(0.8) : type.themeColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            type.label,
                            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // 角标ID
              Positioned(
                top: 12, right: 12,
                child: Text(
                  "#${pet_model.pictorialBookId}",
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'Monospace'),
                ),
              ),
              // 叠加提示
              if (stackCount > 1)
                Positioned(
                  bottom: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                    child: Text("+${stackCount - 1}", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackDecoration(double opacity) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10, width: 1),
      ),
    );
  }
}