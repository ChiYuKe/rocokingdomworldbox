import 'package:flutter/material.dart';
import '../../../models/pet_model.dart';

class EggGroupUI extends StatefulWidget {
  final Color accentColor;
  final List<PetModel> allPets;

  const EggGroupUI({super.key, required this.accentColor, required this.allPets});

  @override
  State<EggGroupUI> createState() => _EggGroupUIState();
}

class _EggGroupUIState extends State<EggGroupUI> {
  PetModel? _selectedPet;
  Map<int, List<PetModel>> _groupedResults = {};
  Map<int, bool> _expandedStates = {};
  final TextEditingController _searchController = TextEditingController();
  
  List<PetModel> _searchSuggestions = [];
  List<PetModel> _searchHistory = []; 
  final FocusNode _focusNode = FocusNode();

  final Map<int, String> _eggGroupNameMap = {
    1: "植物组", 2: "巨灵组", 3: "两栖组", 4: "昆虫组", 5: "天空组",
    6: "动物组", 7: "妖精组", 8: "植物组", 9: "拟人组", 10: "软体组",
    11: "大地组", 12: "魔力组", 13: "海洋组", 14: "龙组", 15: "机械组",
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text;
    if (query.isEmpty) {
      setState(() => _searchSuggestions = []);
      return;
    }
    final suggestions = widget.allPets.where((p) => 
      p.name.contains(query) || p.pictorialBookId.toString().startsWith(query)
    ).take(5).toList();
    setState(() => _searchSuggestions = suggestions);
  }

  void _handleSelectPet(PetModel pet) {
    _focusNode.unfocus();
    _searchController.text = pet.name;
    setState(() {
      _searchHistory.removeWhere((p) => p.id == pet.id);
      _searchHistory.insert(0, pet);
      if (_searchHistory.length > 8) _searchHistory.removeLast();
      _searchSuggestions = []; 
    });
    _calculateMatch(pet);
  }

  void _calculateMatch(PetModel target) {
    setState(() {
      _selectedPet = target;
      _groupedResults = {};
      _expandedStates = {};
      if (target.eggGroup.isEmpty || target.eggGroup.contains(0)) return;

      for (var p in widget.allPets) {
        if (p.id == target.id) continue;
        int commonCount = p.eggGroup.where((id) => target.eggGroup.contains(id)).length;
        if (commonCount > 0) {
          bool isCompatible = !(target.proportionMale == 10 && p.proportionMale == 10) &&
                             !(target.proportionMale == 0 && p.proportionMale == 0);
          if (isCompatible) {
            _groupedResults.putIfAbsent(commonCount, () => []).add(p);
          }
        }
      }

      // 默认所有组都展开
      for (var key in _groupedResults.keys) {
        _expandedStates[key] = true;
      }

      _groupedResults.forEach((key, list) => list.sort((a, b) => a.pictorialBookId.compareTo(b.pictorialBookId)));
    });
  }

  PetModel _findBaseForm(PetModel current) {
    try {
      final prevForm = widget.allPets.firstWhere((p) => p.evolutionPetId.contains(current.id));
      return _findBaseForm(prevForm);
    } catch (_) {
      return current;
    }
  }

  String _getGenderText(int proportionMale) {
    if (proportionMale == 10) return "纯雄性";
    if (proportionMale == 0) return "纯雌性";
    if (proportionMale == -1) return "无性别";
    return "雌雄比例 ♂ $proportionMale : ♀ ${10 - proportionMale}";
  }

  Widget _buildPetAvatar(PetModel p, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: p.mainColor.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: p.mainColor.withOpacity(0.3), width: 1),
      ),
      child: ClipOval(
        child: Transform.scale(
          scale: 1.5,
          child: Image.asset(
            'assets/Icon/BigHeadIcon256/${p.id}.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(
                p.name.isNotEmpty ? p.name[0] : "?",
                style: TextStyle(color: p.mainColor, fontWeight: FontWeight.bold, fontSize: size * 0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchInput(),
            _buildHistoryChips(),
            if (_selectedPet != null) _buildSelectedInfo(),
            Expanded(child: _buildResultList()),
          ],
        ),
        if (_searchSuggestions.isNotEmpty) _buildSuggestionOverlay(),
      ],
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: "搜索精灵名称或图鉴ID",
          hintStyle: const TextStyle(color: Colors.white30),
          prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
          suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(icon: const Icon(Icons.cancel, color: Colors.white24, size: 18), onPressed: () => _searchController.clear())
            : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), 
            borderSide: BorderSide(color: widget.accentColor.withOpacity(0.5), width: 1)
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryChips() {
    if (_searchHistory.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _searchHistory.map((p) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(p.name, style: const TextStyle(fontSize: 10, color: Colors.white60)),
              backgroundColor: Colors.white.withOpacity(0.05),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              side: BorderSide.none,
              onPressed: () => _handleSelectPet(p),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildSuggestionOverlay() {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _searchSuggestions.map((p) => ListTile(
            dense: true,
            title: Text(p.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
            trailing: Text("No.${p.pictorialBookId}", style: const TextStyle(color: Colors.white24, fontSize: 11)),
            onTap: () => _handleSelectPet(p),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildSelectedInfo() {
    final baby = _findBaseForm(_selectedPet!);
    final int gender = _selectedPet!.proportionMale;
    final bool isGenderless = gender == -1;
    
    // 判断是否存在对应性别（10为纯雄，0为纯雌）
    final bool hasFemale = !isGenderless && gender < 10;
    final bool hasMale = !isGenderless && gender > 0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.accentColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧：头像与基本信息
              Column(
                children: [
                  _buildPetAvatar(_selectedPet!, size: 52),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _selectedPet!.eggGroup.map((id) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_eggGroupNameMap[id] ?? "组$id", 
                        style: TextStyle(color: widget.accentColor.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // 右侧内容区
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedPet!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(width: 8),
                        Text("No.${_selectedPet!.pictorialBookId}", style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 12)),
                        const Spacer(),
                        Text(_getGenderText(gender), style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (isGenderless)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                        child: const Text("无性别精灵无法通过常规蛋组繁育", style: TextStyle(color: Colors.redAccent, fontSize: 11)),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoBlock(
                              "作为母方 (♀)", 
                              "决定子代种类", 
                              "孵化获得：${baby.name}", 
                              Colors.orangeAccent,
                              Icons.egg_outlined,
                              isEnabled: hasFemale,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInfoBlock(
                              "作为父方 (♂)", 
                              "遗传技能/个体", 
                              "可提供遗传技能", 
                              Colors.lightBlueAccent,
                              Icons.auto_awesome,
                              isEnabled: hasMale,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBlock(String label, String title, String desc, Color color, IconData icon, {bool isEnabled = true}) {
    // 如果不可用，则使用灰色调
    final displayColor = isEnabled ? color : Colors.white24;
    final displayOpacity = isEnabled ? 1.0 : 0.4;

    return Opacity(
      opacity: displayOpacity,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: displayColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: displayColor.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 10, color: displayColor.withOpacity(0.7)),
                const SizedBox(width: 4),
                Text(label, style: TextStyle(color: displayColor.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: displayColor, fontSize: 12, fontWeight: FontWeight.bold)),
            Text(desc, style: TextStyle(color: displayColor.withOpacity(0.5), fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }


  Widget _buildResultList() {
    if (_selectedPet == null) return const SizedBox.shrink();
    final sortedKeys = _groupedResults.keys.toList()..sort((a, b) => b.compareTo(a));

    return CustomScrollView(
      slivers: [
        ...sortedKeys.map((count) {
          List<PetModel> pets = _groupedResults[count]!;
          bool isPerfect = count >= 2;
          bool isExpanded = _expandedStates[count] ?? true;
          final Color themeColor = isPerfect ? Colors.orangeAccent : Colors.greenAccent;

          return SliverMainAxisGroup(
            slivers: [
              // 吸顶标题栏 + 点击折叠逻辑
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverHeaderDelegate(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandedStates[count] = !isExpanded;
                      });
                    },
                    child: Container(
                      color: const Color(0xFF1A1A1A), // 必须有背景色遮挡滚动内容
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: themeColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(isPerfect ? Icons.whatshot : Icons.eco, size: 14, color: themeColor),
                            const SizedBox(width: 8),
                            Text(
                              isPerfect ? "完美匹配 (双蛋组重合)" : "基础匹配 (单蛋组重合)", 
                              style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 12)
                            ),
                            const Spacer(),
                            Text("${pets.length} 只", style: const TextStyle(color: Colors.white24, fontSize: 11)),
                            const SizedBox(width: 8),
                            // 添加折叠箭头图标
                            Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              size: 16,
                              color: Colors.white24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  maxHeight: 50,
                  minHeight: 50,
                ),
              ),
              // 根据展开状态决定是否渲染列表
              if (isExpanded)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final p = pets[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                        onTap: () => _handleSelectPet(p),
                        leading: _buildPetAvatar(p, size: 36),
                        title: Text(p.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                        subtitle: Text(
                          p.eggGroup.map((id) => _eggGroupNameMap[id]).join(' · '), 
                          style: const TextStyle(color: Colors.white38, fontSize: 10)
                        ),
                        trailing: Text("No.${p.pictorialBookId}", style: const TextStyle(color: Colors.white24, fontSize: 10)),
                      );
                    },
                    childCount: pets.length,
                  ),
                )
              else
                const SliverToBoxAdapter(child: SizedBox.shrink()),
              
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
          );
        }),
      ],
    );
  }

}

// 辅助类：用于定义吸顶头部的行为
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SliverHeaderDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.maxHeight != maxHeight ||
           oldDelegate.minHeight != minHeight ||
           oldDelegate.child != child;
  }
}