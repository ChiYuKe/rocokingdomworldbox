import 'package:flutter/material.dart';


class PetCard extends StatelessWidget {
  final dynamic pet_model; // 数据模型
  final int index; // 当前宠物在列表中的索引
  final bool isSelected; // 是否被选中（用于高亮显示）
  final Function(int) onSelected; // 点击时的回调函数，传递当前宠物的索引

  const PetCard({
    super.key,
    required this.pet_model,
    required this.index,
    required this.isSelected,
    required this.onSelected,
  });


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onSelected(index),
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black.withOpacity(0.8)
                    : const Color.fromARGB(1, 83, 81, 81).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: pet_model.types[0].themeColor.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          isSelected
                              ? pet_model.types[0].themeColor.withOpacity(0.4)
                              : Colors.white10,
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: ClipOval(
                      child: Transform.scale(
                          scale: 1.2, 
                          child: Image.asset(
                            'assets/Icon/BigHeadIcon256/${pet_model.id}.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.pets, color: Colors.white24, size: 28),
                          ),
                        ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet_model.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: pet_model.types[0].themeColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            pet_model.types[0].label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 16,
              child: Text(
                "#${pet_model.pictorialBookId}",
                style: TextStyle(
                  color: isSelected
                      ? pet_model.types[0].themeColor.withOpacity(0.8)
                      : const Color.fromARGB(228, 255, 255, 255),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}