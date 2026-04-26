import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/detail_panel.dart'; 
import '../widgets/card/petcard.dart';



class PokedexTab extends StatefulWidget {
  final List<Pet> pokedex;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color accentColor;

  const PokedexTab({
    super.key,
    required this.pokedex,
    required this.selectedIndex,
    required this.onSelected,
    required this.accentColor,
  });

  @override
  State<PokedexTab> createState() => _PokedexTabState();
}

class _PokedexTabState extends State<PokedexTab> {
  // 将选中的按钮索引提升到此处管理，切换精灵时此状态不会消失
  int _globalLockedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PetListView(
          pokedex: widget.pokedex,
          selectedIndex: widget.selectedIndex,
          onSelected: widget.onSelected,
        ),
        Expanded(
          child: DetailPanel(
            pet: widget.pokedex[widget.selectedIndex],
            accentColor: widget.accentColor,
            lockedIndex: _globalLockedIndex,
            onLockedIndexChanged: (index) {
              setState(() {
                _globalLockedIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}


// 宠物列表组件 
class PetListView extends StatefulWidget {
  final List<Pet> pokedex;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  const PetListView({super.key, required this.pokedex, required this.selectedIndex, required this.onSelected});

  @override
  State<PetListView> createState() => _PetListViewState();
}

class _PetListViewState extends State<PetListView> {
  final ScrollController _scrollController = ScrollController();
  // 记录当前选中的属性集合
  final Set<PetType> _selectedTypes = {};


  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }

  // 通用的弹出窗口方法
  void _showOverlay(BuildContext context, String title, Widget content) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      barrierColor: Colors.black54, // 背景遮罩颜色
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutCubic.transform(anim1.value), // 缩放动画
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A), // 深灰色背景
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
              content: SizedBox(
                width: 300,
                child: content,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("确定", style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 40, bottom: 10, right: 16), // 增加了右内边距
            child: Row( // 使用 Row 包裹标题和按钮
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "精灵图鉴",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildHeaderButton(Icons.search, () {
                      _showOverlay(
                        context, 
                        "搜索精灵", 
                        TextField(
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "输入名称或编号...",
                            hintStyle: const TextStyle(color: Colors.white24),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            prefixIcon: const Icon(Icons.search, color: Colors.white38),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(width: 8),

                    _buildHeaderButton(Icons.tune_rounded, () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: "Filter",
                        barrierColor: Colors.black54,
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (context, anim1, anim2) => StatefulBuilder( // 使用 StatefulBuilder 处理多选状态刷新
                          builder: (context, setModalState) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF1A1A1A),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              title: const Text("属性筛选", style: TextStyle(color: Colors.white, fontSize: 18)),
                              content: SizedBox(
                                width: 300,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 2.0,
                                  ),
                                  itemCount: PetType.values.length,
                                  itemBuilder: (context, index) {
                                    final type = PetType.values[index];
                                    final isSelected = _selectedTypes.contains(type); // 判断是否选中

                                    return GestureDetector(
                                      onTap: () {
                                        setModalState(() { // 刷新弹窗内部状态
                                          if (isSelected) {
                                            _selectedTypes.remove(type);
                                          } else {
                                            _selectedTypes.add(type);
                                          }
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          // --- 核心逻辑：选中显示实色，未选中显示灰色 ---
                                          color: isSelected ? type.themeColor : Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: isSelected ? [
                                            BoxShadow(
                                              color: type.themeColor.withOpacity(0),// 控制发光颜色阴影
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            )
                                          ] : [],
                                          border: Border.all(
                                            color: isSelected ? Colors.white24 : Colors.transparent,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          type.label,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.white38, // 文本颜色同步切换
                                            fontSize: 12,
                                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // 清空选择
                                    setModalState(() => _selectedTypes.clear());
                                  },
                                  child: const Text("重置", style: TextStyle(color: Colors.white38)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      // 这里触发外部列表的过滤逻辑
                                    });
                                  },
                                  child: const Text("确定", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect rect) => const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
                stops: [0.0, 0.00, 0.95, 1.0],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: widget.pokedex.length,
                  itemBuilder: (context, index) => PetCard(
                    pet: widget.pokedex[index],
                    index: index,
                    isSelected: widget.selectedIndex == index,
                    onSelected: (idx) => widget.onSelected(idx), 
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建顶部功能按钮的小部件
  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), // 微弱的半透明背景
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: Icon(
            icon,
            color: Colors.white70,
            size: 20,
          ),
        ),
      ),
    );
  }


}




