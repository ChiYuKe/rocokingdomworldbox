import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/skill_model.dart';
import 'models/chat_message.dart';
import 'tabs/pokedex_tab.dart';
import 'tabs/settings_tab.dart';
import 'tabs/hub_tab.dart';
import 'tabs/plugins_tab.dart';
import 'models/plugin_interface.dart';
import 'plugins/calc_plugin/main.dart' as calc;
import 'plugins/update_pet_data_plugin/main.dart' as update_pet_data;
import 'plugins/auto_script_plugin/main.dart' as auto_script;
import 'plugins/egg_group_plugin/main.dart' as egg_group;
import 'models/settingsprovider.dart';
import 'services/data_sync_service.dart';
import 'models/pet_model.dart';
import 'tabs/map_tab.dart';
import 'models/sync_config.dart';
import 'models/pet_evolution.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // 初始化持久化配置
  final settings = SettingsProvider();
  await settings.init();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Env Load Error: $e");
  }

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? "default_url",
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? "default_anon_key", 
  );


  runApp(RocoPokedexApp(settings: settings)); 
}


class RocoPokedexApp extends StatelessWidget {
  final SettingsProvider settings;
  const RocoPokedexApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'MIANFEIZITI',
            brightness: Brightness.dark,
          ),
          home: MainScaffold(settings: settings),
        );
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  final SettingsProvider settings;
  const MainScaffold({super.key, required this.settings});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}



class _MainScaffoldState extends State<MainScaffold> with WindowListener {
  late Isar _isar;
  List<PetModel> _pictorialBookId = [];
  List<RocoPlugin> _plugins = [];
  bool _isLoading = true;
  final GlobalKey<HubTabState> _chatTabKey = GlobalKey<HubTabState>();

  int _currentTab = 0;
  int _selectedIndex = 0;
  bool _isMaximized = false;
  bool _isAlwaysOnTop = false; // 置顶状态跟踪

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

  @override
  void onWindowMaximize() {
    setState(() => _isMaximized = true);
  }

  @override
  void onWindowUnmaximize() {
    setState(() => _isMaximized = false);
  }

  Future<void> _toggleAlwaysOnTop() async {
    final bool isTop = await windowManager.isAlwaysOnTop();
    await windowManager.setAlwaysOnTop(!isTop);
    setState(() {
      _isAlwaysOnTop = !isTop;
    });
  }

  Future<void> _initApp() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      
      _isar = Isar.getInstance() ?? await Isar.open(
        [
          SkillModelSchema,
          ChatMessageSchema,
          PetModelSchema,
          SyncConfigSchema,
          PetEvolutionSchema,
        ], 
        directory: dir.path
      );

      final syncService = DataSyncService(_isar);
      await syncService.runAllSync();

      final allPets = await _isar.petModels.where().findAll();
      
      if (mounted) {
        setState(() {
          _pictorialBookId = allPets;
          _plugins = [
            calc.CalcPlugin(pictorialBookId: _pictorialBookId),
            update_pet_data.UpdatePetDataPlugin(),
            auto_script.AutoScriptPlugin(),
            egg_group.EggGroupPlugin(allPets: _pictorialBookId),
          ];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Initialization Error: $e");
    }
  }

  Color _getCurrentThemeColor() {
    final settings = widget.settings;
    if (settings.isColorLocked) {
      return settings.selectedType.themeColor;
    }
    
    if (_pictorialBookId.isEmpty || _selectedIndex >= _pictorialBookId.length) {
      return Colors.blue; 
    }
    
    final currentPet = _pictorialBookId[_selectedIndex];
    return currentPet.types.isNotEmpty ? currentPet.types[0].themeColor : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
      );
    }

    final Color currentEffectiveColor = _getCurrentThemeColor();
    final Color backgroundColor = Color.lerp(
      const Color(0xFF000000),
      currentEffectiveColor,
      widget.settings.colorIntensity,
    ) ?? Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              color: backgroundColor,
            ),
          ),
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
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildTopTitleBar(currentEffectiveColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTitleBar(Color accentColor) {
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
          _buildWindowControls(accentColor),
        ],
      ),
    );
  }

  Widget _buildWindowControls(Color accentColor) {
    return Row(
      children: [
        // 置顶按钮：根据 _isAlwaysOnTop 切换图标和样式
        WindowBtn(
          icon: _isAlwaysOnTop ? Icons.push_pin : Icons.push_pin_outlined, 
          onTap: _toggleAlwaysOnTop,
          isActive: _isAlwaysOnTop,
          activeColor: accentColor,
        ),
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

  Widget _buildIndexedTabContent(Color accentColor) {
    return IndexedStack(
      index: _currentTab,
      children: [
        PokedexTab(
          pictorialBookId: _pictorialBookId,
          selectedIndex: _selectedIndex,
          onSelected: (index) => setState(() => _selectedIndex = index),
          accentColor: accentColor,
        ),
        HubTab(
          key: _chatTabKey, 
          accentColor: accentColor,
          isar: _isar,
        ),
        MapTab(plugins: _plugins, accentColor: accentColor),
        PluginsTab(plugins: _plugins, accentColor: accentColor),
        SettingsTab(
          accentColor: accentColor,
          settings: widget.settings,
        ),
      ],
    );
  }

  Widget _buildNavigationRail(Color accentColor) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 30),
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
          _buildNavBtn(1, Icons.groups_rounded, "聊天室", accentColor),
          const SizedBox(height: 12),
          _buildNavBtn(2, Icons.map_rounded, "地图", accentColor),
          const SizedBox(height: 12),
          _buildNavBtn(3, Icons.extension_rounded, "插件", accentColor),
          const SizedBox(height: 12),
          _buildNavBtn(4, Icons.settings_rounded, "设置", accentColor),
        ],
      ),
    );
  }

  Widget _buildNavBtn(int index, IconData icon, String label, Color accentColor) {
    final bool isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () { 
        if (_currentTab == index) return;
        setState(() => _currentTab = index);
        if (index == 1) {
          _chatTabKey.currentState?.initialize();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.9) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
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

class WindowBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;
  final bool isActive;
  final Color? activeColor;

  const WindowBtn({
    super.key, 
    required this.icon, 
    required this.onTap, 
    this.isClose = false,
    this.isActive = false,
    this.activeColor,
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
                ? (widget.isClose ? Colors.red.withOpacity(0.8) : Colors.white.withOpacity(0.1))
                : (widget.isActive ? (widget.activeColor?.withOpacity(0.2) ?? Colors.white10) : Colors.transparent),
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: widget.isActive 
                  ? (widget.activeColor ?? Colors.white)
                  : (_isHovered ? Colors.white : Colors.white.withOpacity(0.6)),
              size: widget.icon == Icons.filter_none ? 12 : 16,
            ),
          ),
        ),
      ),
    );
  }
}