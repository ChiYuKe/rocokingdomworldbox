import 'package:flutter/material.dart';
import '../models/plugin_interface.dart';

class PluginsTab extends StatelessWidget {
  final List<RocoPlugin> plugins;
  final Color accentColor;

  const PluginsTab({
    super.key,
    required this.plugins,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
        borderRadius: BorderRadius.all(Radius.circular(35)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            Expanded(child: _buildPluginGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("插件扩展", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            _buildBadge(),
          ],
        ),
        const SizedBox(height: 8),
        Text("通过插件扩展来增强图鉴功能", style: TextStyle(color: Colors.white.withOpacity(0.4))),
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Text("${plugins.length}", style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPluginGrid(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemCount: plugins.length + 1,
      itemBuilder: (context, index) {
        if (index < plugins.length) {
          return _buildPluginCard(context, plugins[index]);
        }
        // return _buildAddMoreCard();
      },
    );
  }

Widget _buildPluginCard(BuildContext context, RocoPlugin plugin) {
    return GestureDetector(
      onTap: () {
        if (plugin.isLocked) {
          _showAuthDialog(context, plugin);
        } else {
          _navigateToPlugin(context, plugin);
        }
      },
      child: Stack(
        children: [
          // 底层卡片主体
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF151515).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              // 锁定状态使用主题色边框，普通状态使用暗色边框
              border: Border.all(
                color: plugin.isLocked 
                    ? accentColor.withOpacity(0.3) 
                    : Colors.white.withOpacity(0.08),
                width: plugin.isLocked ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: plugin.buildIcon(context, accentColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(plugin.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          Text(plugin.version, style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plugin.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11, height: 1.2),
                      ),
                      const SizedBox(height: 6),
                      Text("@${plugin.author}", style: TextStyle(color: accentColor.withOpacity(0.5), fontSize: 10, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 锁定图标装饰
          if (plugin.isLocked)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_rounded, size: 14, color: accentColor),
              ),
            ),
        ],
      ),
    );
  }

  // 弹出验证对话框
  void _showAuthDialog(BuildContext context, RocoPlugin plugin) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D), 
        title: const Text("插件授权", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "使用「${plugin.name}」需要输入授权码",
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "请输入秘钥",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white12),
                ),
              ),
              obscureText: true, // 隐藏输入内容
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("取消", style: TextStyle(color: Colors.white.withOpacity(0.5))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: accentColor),
            onPressed: () {
              // 校验 CalcPlugin 中定义的秘钥
              if (controller.text == plugin.correctKey) {
                Navigator.pop(context); // 关闭对话框
                _navigateToPlugin(context, plugin); // 进入插件
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("秘钥验证失败，请重试")),
                );
              }
            },
            child: const Text("确定", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 统一的跳转方法
  void _navigateToPlugin(BuildContext context, RocoPlugin plugin) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => plugin.buildEntryPage(context, accentColor),
      ),
    );
  }
}