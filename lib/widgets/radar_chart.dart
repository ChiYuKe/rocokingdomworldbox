import 'package:flutter/material.dart';
import 'dart:math' as math;

class StatRadarChart extends StatelessWidget {
  /// 外部传入的数据顺序固定为：[生命, 物攻, 魔攻, 物防, 魔防, 速度]
  final List<double> stats;
  final Color color;
  final String backgroundImage = 'assets/ui/UI_PetInfoRadraBg.png';

  /// 内部 UI 绘制的顺序（从 12 点钟方向顺时针）：
  /// 0: 精力 (对应传入的 stats[0])
  /// 1: 魔攻 (对应传入的 stats[2])
  /// 2: 魔抗 (对应传入的 stats[4])
  /// 3: 速度 (对应传入的 stats[5])
  /// 4: 防御 (对应传入的 stats[3])
  /// 5: 物攻 (对应传入的 stats[1])
  static const List<int> _drawMapping = [0, 2, 4, 5, 3, 1];

  static const List<String> _iconNames = [
    'ui_hp',    // 位置 0
    'ui_matk',  // 位置 1
    'ui_mdef',  // 位置 2
    'ui_speed', // 位置 3
    'ui_def',   // 位置 4
    'ui_atk',   // 位置 5
  ];

  const StatRadarChart({
    super.key,
    required this.stats,
    required this.color,
  });

  /// 根据映射获取转换后的数据列表
  List<double> get _mappedStats {
    if (stats.length < 6) return stats;
    return _drawMapping.map((index) => stats[index]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = math.min(constraints.maxWidth, constraints.maxHeight);
      
      final double dataRadius = size / 2 * 0.75;
      final double iconRadius = size / 2 * 0.92;

      final mappedData = _mappedStats;

      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 背景图
            Image.asset(
              backgroundImage,
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
            // 雷达数据绘制 - 使用自定义的 ListDoubleTween
            TweenAnimationBuilder<List<double>>(
              tween: ListDoubleTween(
                begin: List.filled(6, 0.0), 
                end: mappedData
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuart,
              builder: (context, animatedStats, _) => CustomPaint(
                size: Size(size, size),
                painter: RadarChartPainter(animatedStats, color, dataRadius),
              ),
            ),
            // 顶点图标
            ..._buildIcons(iconRadius, size / 10),
          ],
        ),
      );
    });
  }

  List<Widget> _buildIcons(double radius, double iconSize) {
    return List.generate(_iconNames.length, (i) {
      final double angle = i * (2 * math.pi / 6) - math.pi / 2;
      return _PositionedComponent(
        angle: angle,
        radius: radius,
        child: Image.asset(
          'assets/ui/${_iconNames[i]}.png',
          width: iconSize,
          height: iconSize,
          errorBuilder: (context, _, __) => Icon(
            Icons.help_outline, 
            size: iconSize * 0.8, 
            color: Colors.white24
          ),
        ),
      );
    });
  }
}

/// 自定义 Tween 用于处理 List<double> 的平滑过渡
class ListDoubleTween extends Tween<List<double>> {
  ListDoubleTween({super.begin, super.end});

  @override
  List<double> lerp(double t) {
    final start = begin ?? [];
    final finish = end ?? [];
    if (start.length != finish.length) return finish;

    return List.generate(start.length, (i) {
      // 对列表中的每个数值进行线性插值计算
      return start[i] + (finish[i] - start[i]) * t;
    });
  }
}

class _PositionedComponent extends StatelessWidget {
  final double angle;
  final double radius;
  final Widget child;

  const _PositionedComponent({
    required this.angle,
    required this.radius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(radius * math.cos(angle), radius * math.sin(angle)),
      child: child,
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List<double> stats;
  final Color color;
  final double baseRadius;

  static const int _maxStat = 250;

  RadarChartPainter(this.stats, this.color, this.baseRadius);

  @override
  void paint(Canvas canvas, Size size) {
    if (stats.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    const int sides = 6;
    const double angleStep = 2 * math.pi / sides;

    final statPath = Path();
    final List<Offset> points = [];

    for (int j = 0; j < sides; j++) {
      final double angle = j * angleStep - math.pi / 2;
      final double normalizedStat = (stats[j] / _maxStat).clamp(0.0, 1.0);
      final double currentRadius = baseRadius * normalizedStat;

      final double x = center.dx + currentRadius * math.cos(angle);
      final double y = center.dy + currentRadius * math.sin(angle);
      points.add(Offset(x, y));

      if (j == 0) {
        statPath.moveTo(x, y);
      } else {
        statPath.lineTo(x, y);
      }
    }
    statPath.close();

    canvas.drawPath(
      statPath, 
      Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.fill
    );
    
    canvas.drawPath(
      statPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeJoin = StrokeJoin.round,
    );

    // final pointPaint = Paint()..color = Colors.white;
    // final pointStrokePaint = Paint()
    //   ..color = color
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1.5;

    // for (var point in points) {
    //   canvas.drawCircle(point, 3.0, pointPaint);
    //   canvas.drawCircle(point, 3.0, pointStrokePaint);
    // }
  }

  @override
  bool shouldRepaint(RadarChartPainter old) => 
      old.stats != stats || old.color != color;
}