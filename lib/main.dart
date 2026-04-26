import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/pet.dart';
import 'models/chat_message.dart';
import 'tabs/pokedex_tab.dart';
import 'tabs/settings_tab.dart';
import 'tabs/hub_tab.dart';
import 'tabs/plugins_tab.dart';
import 'models/plugin_interface.dart';
import 'plugins/calc_plugin/main.dart' as calc;
import 'plugins/update_pet_data_plugin/main.dart' as update_pet_data;
import 'plugins/auto_script_plugin/main.dart' as auto_script;
import 'models/settingsprovider.dart';

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

  // 将 settings 实例传给根组件
  runApp(RocoPokedexApp(settings: settings)); 
}

class RocoPokedexApp extends StatelessWidget {
  final SettingsProvider settings;
  const RocoPokedexApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    // 使用 ListenableBuilder 监听全局设置变化
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
  List<Pet> _pokedex = [];
  List<RocoPlugin> _plugins = [];
  bool _isLoading = true;
  final GlobalKey<HubTabState> _chatTabKey = GlobalKey<HubTabState>();

  int _currentTab = 0;
  int _selectedIndex = 0;
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

  @override
  void onWindowMaximize() {
    setState(() => _isMaximized = true);
  }

  @override
  void onWindowUnmaximize() {
    setState(() => _isMaximized = false);
  }

  Future<void> _initApp() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [PetSchema, AbilitySchema, ChatMessageSchema], directory: dir.path);

    final petCount = await _isar.pets.count();
    
    if (petCount == 0) {
      try {
        final String abiRes = await rootBundle.loadString('assets/data/abilities.json');
        final List<dynamic> abiData = json.decode(abiRes)['data'];
        final abilities = abiData.map((item) => Ability()
          ..aid = item['id']
          ..name = item['name']
          ..description = item['description']
          ..image = item['image']).toList();

        final String jsonString = await rootBundle.loadString('assets/data/pokedex.json');
        final List<dynamic> petData = json.decode(jsonString)['data'];
        final List<Pet> newPets = petData.map((item) => Pet.fromJson(item)).toList();

        await _isar.writeTxn(() async {
          await _isar.abilitys.putAll(abilities);
          await _isar.pets.putAll(newPets);
        });
      } catch (e) {
        debugPrint("Data Init Error: $e");
      }
    }

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

    // 核心修改：背景色逻辑直接读取 widget.settings 中的持久化值
    final settings = widget.settings;
    final Color currentEffectiveColor = settings.isColorLocked
        ? settings.selectedType.themeColor
        : (_pokedex.isNotEmpty ? _pokedex[_selectedIndex].types[0].themeColor : Colors.blue);

    final Color backgroundColor = Color.lerp(
      const Color.fromARGB(255, 0, 0, 0),
      currentEffectiveColor,
      settings.colorIntensity,
    )!;

    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(child: Container(color: backgroundColor)),
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
            child: _buildTopTitleBar(),
          ),
        ],
      ),
    );
  }

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
        HubTab(
          key: _chatTabKey, 
          accentColor: accentColor,
          isar: _isar,
        ),
        PluginsTab(plugins: _plugins, accentColor: accentColor),
        SettingsTab(
          accentColor: accentColor,
          settings: widget.settings, // 将 Provider 传入设置页
        ),
      ],
    );
  }

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
          _buildNavBtn(2, Icons.extension_rounded, "插件", accentColor),
          const SizedBox(height: 12),
          _buildNavBtn(3, Icons.settings_rounded, "设置", accentColor),
        ],
      ),
    );
  }

  Widget _buildNavBtn(int index, IconData icon, String label, Color accentColor) {
    final bool isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () { 
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

class WindowBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;
  const WindowBtn({super.key, required this.icon, required this.onTap, this.isClose = false});
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