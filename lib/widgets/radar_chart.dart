import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 用于展示各项能力指标（雷达图/蜘蛛网图）的 StatelessWidget。
class StatRadarChart extends StatelessWidget {
  // 存储各项能力的数值列表，顺序为 [HP, 物攻, 魔攻, 物防, 魔防, 速度]，数值范围为0-350。
  final List<double> stats;
  // 雷达图填充区域及边框的主色调。
  final Color color;

  const StatRadarChart({
    super.key, 
    required this.stats, 
    required this.color,
  });

  @override
  Widget build(BuildContext context) => 
    // TweenAnimationBuilder 用于创建隐式动画，它会自动处理从 begin 到 end 之间的数值过渡
    TweenAnimationBuilder<double>(
      // 动画范围从 0.0（完全收缩在中心）到 1.0（完全展开到实际数值）
      tween: Tween(begin: 0.0, end: 1.0),
      
      // 动画持续时间
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      builder: (context, animationValue, child) => 
        CustomPaint(
          // 占据父容器提供的所有可用空间
          size: Size.infinite,
          
          // 将原始数据、当前的动画进度值以及颜色传递给自定义画笔
          // animationValue 通常在 Painter 内部用于计算：实际坐标 = 原始坐标 * animationValue
          painter: RadarChartPainter(stats, animationValue, color),
        ),
    );
}

/// 实际绘制雷达图的 CustomPainter，负责根据传入的 stats 和 animationValue 绘制动态雷达图
class RadarChartPainter extends CustomPainter {
  final List<double> stats;
  final double animationValue;
  final Color color;

  // 优化：将固定参数提取为常量或配置
  static const int _maxStat = 350; // 最大属性值基准
  static const int _gridLevels = 4; // 背景网格层数

  RadarChartPainter(this.stats, this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (stats.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.85;
    
    // 根据 stats 的长度动态计算边数，增强通用性
    final int sides = stats.length;
    final double angleStep = 2 * math.pi / sides;

    // 绘制背景网格（蜘蛛网）
    // 重用 Paint 对象，避免在循环内创建
    final webPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= _gridLevels; i++) {
      final double r = radius * (i / _gridLevels);
      // 提取绘制多边形的逻辑
      _drawPolygon(canvas, center, r, sides, angleStep, webPaint);
    }

    // 绘制数据区域
    // 将 Path 的创建和 Paint 属性设置集中处理
    final statPath = Path();
    
    for (int j = 0; j < sides; j++) {
      final double angle = j * angleStep - math.pi / 2;
      // 优化：增加数值保护，防止越界
      final double normalizedStat = (stats[j] / _maxStat).clamp(0.0, 1.0);
      final double currentRadius = radius * normalizedStat * animationValue;

      final double x = center.dx + currentRadius * math.cos(angle);
      final double y = center.dy + currentRadius * math.sin(angle);

      if (j == 0) {
        statPath.moveTo(x, y);
      } else {
        statPath.lineTo(x, y);
      }
    }
    statPath.close();

    // 绘制填充层
    canvas.drawPath(
      statPath,
      Paint()
        ..color = color.withOpacity(0.4)
        ..style = PaintingStyle.fill,
    );

    // 绘制边框层
    canvas.drawPath(
      statPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  /// 辅助方法：绘制一个正多边形
  void _drawPolygon(Canvas canvas, Offset center, double r, int sides, double angleStep, Paint paint) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final double angle = i * angleStep - math.pi / 2;
      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter old) {
    // 增加对 stats 引用或内容的比对，确保在数据变化时正确重绘
    return old.animationValue != animationValue || 
           old.color != color || 
           old.stats != stats;
  }
}
