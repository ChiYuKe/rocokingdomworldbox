import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class PluginPageTemplate extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color accentColor;
  final Widget body;

  const PluginPageTemplate({
    super.key,
    required this.title,
    this.subTitle = "DATA ANALYSIS SYSTEM",
    required this.accentColor,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // 修复版的导航栏
            _buildHeader(context),
            
            // 顶部分割线
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white.withOpacity(0.05),
            ),
            
            // 插件主体内容
            Expanded(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
  // 构建导航栏，包含原生拖动、双击最大化/还原以及返回按钮
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Stack(
        children: [
          // 底层原生拖动感应
          const DragToMoveArea(
            child: SizedBox.expand(),
          ),

          // 中层双击感应
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTap: () async {
              if (await windowManager.isMaximized()) {
                windowManager.unmaximize();
              } else {
                windowManager.maximize();
              }
            },
            child: const SizedBox.expand(),
          ),

          //顶层 UI 交互
          Row(
            children: [
              const SizedBox(width: 16),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 3,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    title.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 11),
                                child: Text(
                                  subTitle,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: Icon(Icons.layers_outlined, color: accentColor, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}