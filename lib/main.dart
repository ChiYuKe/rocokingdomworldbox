import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';

import 'models/pet.dart';
import 'tabs/pokedex_tab.dart';
import 'tabs/settings_tab.dart';
import 'tabs/comparison_tab.dart';
import 'tabs/plugins_tab.dart';
import 'models/plugin_interface.dart';
import 'plugins/calc_plugin/main.dart' as calc;
import 'plugins/update_pet_data_plugin/main.dart' as update_pet_data;
import 'plugins/auto_script_plugin/main.dart' as auto_script;

/// 应用程序入口：负责系统级服务的初始化配置
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 配置桌面端原生窗口属性
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(1000, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  // 窗口就绪后展示
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // 加载环境配置文件
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Env Load Error: $e");
  }

  runApp(const RocoPokedexApp());
}

/// 应用程序根组件：定义全局样式主题
class RocoPokedexApp extends StatelessWidget {
  const RocoPokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'MIANFEIZITI',
        brightness: Brightness.dark,
      ),
      home: const MainScaffold(),
    );
  }
}

/// 桌面端主骨架：管理整体布局、数据加载及窗口状态监听
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> with WindowListener {
  // 核心业务数据
  late Isar _isar;
  List<Pet> _pokedex = [];
  List<RocoPlugin> _plugins = [];
  bool _isLoading = true;

  // 交互状态控制
  int _currentTab = 0;
  int _selectedIndex = 0;
  bool _isColorLocked = false;
  PetType _selectedType = PetType.light;
  double _colorIntensity = 0.8;

  // 窗口状态记录
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initApp();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  /// 响应原生窗口最大化事件
  @override
  void onWindowMaximize() {
    setState(() => _isMaximized = true);
  }

  /// 响应原生窗口取消最大化事件
  @override
  void onWindowUnmaximize() {
    setState(() => _isMaximized = false);
  }

  /// 异步初始化数据库并加载资源文件
  Future<void> _initApp() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([PetSchema, AbilitySchema], directory: dir.path);

    await _isar.writeTxn(() async {
      try {
        final String abiRes = await rootBundle.loadString('assets/data/abilities.json');
        final List<dynamic> abiData = json.decode(abiRes)['data'];
        final abilities = abiData.map((item) => Ability()
          ..aid = item['id']
          ..name = item['name']
          ..description = item['description']
          ..image = item['image']).toList();
        await _isar.abilitys.putAll(abilities);

        final String jsonString = await rootBundle.loadString('assets/data/pokedex.json');
        final List<dynamic> petData = json.decode(jsonString)['data'];
        final List<Pet> newPets = petData.map((item) => Pet.fromJson(item)).toList();
        await _isar.pets.putAll(newPets);
      } catch (e) {
        debugPrint("Data Init Error: $e");
      }
    });

    final allPets = await _isar.pets.where().findAll();
    if (mounted) {
      setState(() {
        _pokedex = allPets;
        _plugins = [
          calc.CalcPlugin(pokedex: _pokedex),
          update_pet_data.UpdatePetDataPlugin(),
          auto_script.AutoScriptPlugin()
        ];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // 计算当前动态背景色
    final Color currentEffectiveColor = _isColorLocked
        ? _selectedType.themeColor
        : (_pokedex.isNotEmpty ? _pokedex[_selectedIndex].types[0].themeColor : Colors.blue);

    final Color backgroundColor = Color.lerp(
      const Color.fromARGB(255, 0, 0, 0),
      currentEffectiveColor,
      _colorIntensity,
    )!;

    return Scaffold(
      body: Stack(
        children: [
          // 动态渐变背景
          RepaintBoundary(child: Container(color: backgroundColor)),
          
          // 内容主体布局
          Row(
            children: [
              _buildNavigationRail(currentEffectiveColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 33, right: 12, bottom: 12), 
                  child: _buildIndexedTabContent(currentEffectiveColor),
                ),
              ),
            ],
          ),

          // 悬浮式自定义标题栏
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildTopTitleBar(),
          ),
        ],
      ),
    );
  }

  /// 构建标题栏：包含拖动区域和控制按钮
  Widget _buildTopTitleBar() {
    return Container(
      height: 33,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onDoubleTap: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
              child: const DragToMoveArea(child: SizedBox.expand()),
            ),
          ),
          _buildWindowControls(),
        ],
      ),
    );
  }

  /// 窗口控制按钮组
  Widget _buildWindowControls() {
    return Row(
      children: [
        WindowBtn(icon: Icons.remove, onTap: () => windowManager.minimize()),
        WindowBtn(
          icon: _isMaximized ? Icons.filter_none : Icons.crop_square,
          onTap: () async {
            if (_isMaximized) {
              await windowManager.unmaximize();
            } else {
              await windowManager.maximize();
            }
          },
        ),
        WindowBtn(icon: Icons.close, onTap: () => windowManager.close(), isClose: true),
      ],
    );
  }

  /// 多页面切换容器：使用 IndexedStack 保持各页面状态
  Widget _buildIndexedTabContent(Color accentColor) {
    return IndexedStack(
      index: _currentTab,
      children: [
        PokedexTab(
          pokedex: _pokedex,
          selectedIndex: _selectedIndex,
          onSelected: (index) => setState(() => _selectedIndex = index),
          accentColor: accentColor,
        ),
        ComparisonTab(pokedex: _pokedex, accentColor: accentColor),
        PluginsTab(plugins: _plugins, accentColor: accentColor),
        SettingsTab(
          accentColor: accentColor,
          isColorLocked: _isColorLocked,
          selectedType: _selectedType,
          colorIntensity: _colorIntensity,
          onLockChanged: (v) => setState(() => _isColorLocked = v),
          onTypeChanged: (t) => setState(() => _selectedType = t),
          onIntensityChanged: (v) => setState(() => _colorIntensity = v),
        ),
      ],
    );
  }

  /// 构建侧边导航栏容器
  Widget _buildNavigationRail(Color accentColor) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Color.lerp(const Color(0xFF1A1A1A), accentColor, 0.05),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Icon(Icons.catching_pokemon, color: accentColor, size: 30),
          const Spacer(),
          _buildNavGroup(accentColor),
          const Spacer(),
        ],
      ),
    );
  }

  /// 侧边栏按钮组合：背景修饰与按钮堆叠
  Widget _buildNavGroup(Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavBtn(0, Icons.auto_awesome_motion_rounded, "图鉴", accentColor),
          const SizedBox(height: 12),
          _buildNavBtn(1, Icons.compare_arrows_rounded, "克制", accentColor),
          const SizedBox(height: 12),
          _buildNavBtn(2, Icons.extension_rounded, "插件", accentColor),
          const SizedBox(height: 12),
          _buildNavBtn(3, Icons.settings_rounded, "设置", accentColor),
        ],
      ),
    );
  }

  /// 导航按钮：处理点击反馈及动画效果
  Widget _buildNavBtn(int index, IconData icon, String label, Color accentColor) {
    final bool isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.9) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isSelected ? [
            BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
          ] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.white30, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white30,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 窗口功能按钮：实现悬停颜色渐变，不含缩放效果
class WindowBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;

  const WindowBtn({
    super.key,
    required this.icon,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<WindowBtn> createState() => _WindowBtnState();
}

class _WindowBtnState extends State<WindowBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 46,
          height: 33,
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.isClose 
                    ? Colors.red.withOpacity(0.8) 
                    : Colors.white.withOpacity(0.1))
                : Colors.transparent,
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: _isHovered ? Colors.white : Colors.white.withOpacity(0.6),
              size: widget.icon == Icons.filter_none ? 12 : 16,
            ),
          ),
        ),
      ),
    );
  }
}