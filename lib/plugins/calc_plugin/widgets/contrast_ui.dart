import 'package:flutter/material.dart';
import 'package:rocokingdomworldbox/models/pet_model.dart';
import '../../../models/skill_model.dart';

class ContrastUI extends StatefulWidget {
  final Color accentColor;
  final List<PetModel> pictorialBookId;

  const ContrastUI({super.key, required this.accentColor, required this.pictorialBookId});

  @override
  State<ContrastUI> createState() => _ContrastUIState();
}

class _ContrastUIState extends State<ContrastUI> {
  int _indexA = 0;
  int _indexB = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.pictorialBookId.isEmpty) return const SizedBox();
    final a = widget.pictorialBookId[_indexA];
    final b = widget.pictorialBookId.length > 1 ? widget.pictorialBookId[_indexB] : a;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Column(
        children: [
          _buildSystemHeader(a, b),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 6,
              itemBuilder: (context, index) {
                final List<String> labels = ["HP", "ATK", "DEF", "SPA", "SPD", "SPE"];
                return _buildStatCompareCard(labels[index], a.stats[index], b.stats[index]);
              },
            ),
          ),
          _buildSummaryFooter(a, b),
        ],
      ),
    );
  }

  // --- 头部设计：模块化对比 ---
  Widget _buildSystemHeader(PetModel a, PetModel b) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF111113),
        border: Border(bottom: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildHeaderSubject(a, true, "01")),
          Container(
            width: 1,
            height: 30,
            color: Colors.white.withOpacity(0.05),
          ),
          Expanded(child: _buildHeaderSubject(b, false, "02")),
        ],
      ),
    );
  }

  Widget _buildHeaderSubject(PetModel pet, bool isLeft, String id) {
    return GestureDetector(
      onTap: () => _showPetSelection(isLeft),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              "SUBJECT_$id",
              style: TextStyle(color: widget.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            Text(
              pet.name.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              pet.types[0].label.toUpperCase(),
              style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // --- 核心能力行：数值对比 ---
  Widget _buildStatCompareCard(String label, num valA, num valB) {
    final diff = (valA - valB).abs().toInt();
    final bool aIsHigher = valA > valB;
    const double maxVal = 200.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF111113),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatValue(valA.toInt(), aIsHigher),
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              _buildStatValue(valB.toInt(), !aIsHigher && valA != valB),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Transform.scale(
                      scaleX: -1,
                      child: _buildLinearBar(valA / maxVal, aIsHigher),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: _buildLinearBar(valB / maxVal, !aIsHigher && valA != valB),
                  ),
                ],
              ),
              if (diff != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: const Color(0xFF0A0A0B),
                  child: Text(
                    "Δ $diff",
                    style: TextStyle(
                      color: aIsHigher ? widget.accentColor : Colors.white60,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatValue(int value, bool isBetter) {
    return Text(
      value.toString().padLeft(3, '0'),
      style: TextStyle(
        color: isBetter ? widget.accentColor : Colors.white,
        fontSize: 16,
        fontFamily: 'monospace',
        fontWeight: isBetter ? FontWeight.w900 : FontWeight.w400,
      ),
    );
  }

  Widget _buildLinearBar(double percent, bool highlight) {
    return Container(
      height: 2,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percent.clamp(0.01, 1.0),
        child: Container(color: highlight ? widget.accentColor : Colors.white30),
      ),
    );
  }

  // --- 底部：总和数据分析 ---
  Widget _buildSummaryFooter(PetModel a, PetModel b) {
    final sumA = a.stats.reduce((v, e) => v + e).toInt();
    final sumB = b.stats.reduce((v, e) => v + e).toInt();

    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: MediaQuery.of(context).padding.bottom + 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 37),
        border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      child: Row(
        children: [
          _buildTotalBlock("BST.SOURCE_A", sumA, sumA >= sumB),
          const Spacer(),
          _buildTotalBlock("BST.SOURCE_B", sumB, sumB >= sumA),
        ],
      ),
    );
  }

  Widget _buildTotalBlock(String label, int total, bool isWinner) {
    return Column(
      crossAxisAlignment: isWinner ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              total.toString(),
              style: TextStyle(
                color: isWinner ? widget.accentColor : Colors.white,
                fontSize: 28,
                fontWeight: isWinner ? FontWeight.w900 : FontWeight.w200,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 4),
            if (isWinner)
              Icon(Icons.check_circle_outline, size: 12, color: widget.accentColor),
          ],
        ),
      ],
    );
  }

  //  弹出选择面板 
  void _showPetSelection(bool isA) {
    // 内部状态管理：用于处理搜索过滤
    String searchQuery = "";

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0E10),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        return StatefulBuilder( // 使用 StatefulBuilder 局部刷新搜索结果
          builder: (context, setSheetState) {
            // 过滤逻辑
            final filteredList = widget.pictorialBookId.where((pet) {
              return pet.name.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85, // 增加高度以便搜索输入
              child: Column(
                children: [
                  _buildSheetHeader(isA),
                  
                  // 搜索栏
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15171A),
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.03))),
                    ),
                    child: TextField(
                      onChanged: (value) => setSheetState(() => searchQuery = value),
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'monospace'),
                      cursorColor: widget.accentColor,
                      decoration: InputDecoration(
                        hintText: "按名称搜索...",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.1), fontSize: 12, letterSpacing: 1),
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.2), size: 18),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),

                  // 数据列表 
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredList.length,
                      itemBuilder: (context, i) {
                        final pet = filteredList[i];
                        // 寻找在原始列表中的索引以保持选中状态逻辑
                        final originalIndex = widget.pictorialBookId.indexOf(pet);
                        final bool isSelected = isA ? _indexA == originalIndex : _indexB == originalIndex;
                        final int totalStats = pet.stats.reduce((v, e) => v + e).toInt();
                        
                        return _buildSelectionTile(pet, totalStats, isSelected, isA, originalIndex);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  // 精灵选择面板
  Widget _buildSelectionTile(PetModel pet, int totalStats, bool isSelected, bool isA, int index) {
    return InkWell(
      onTap: () {
        setState(() => isA ? _indexA = index : _indexB = index);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.02))),
          color: isSelected ? widget.accentColor.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            // 编号
            SizedBox(
              width: 32,
              child: Text(
                (index + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                  color: isSelected ? widget.accentColor : Colors.white10,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // 详细信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 遍历精灵的所有属性，为每个属性生成一个颜色圆点
                      ...pet.types.map((type) => Container(
                        margin: const EdgeInsets.only(right: 4), // 圆点之间的间距
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: type.themeColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: type.themeColor.withOpacity(0.3),
                              blurRadius: 4,
                            )
                          ],
                        ),
                      )).toList(),
                      
                      // 如果没有属性，显示默认灰色圆点
                      if (pet.types.isEmpty)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),

            // BST 总值 
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  totalStats.toString(),
                  style: TextStyle(
                    color: isSelected ? widget.accentColor : Colors.white60,
                    fontSize: 20,
                    fontFamily: 'monospace',
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w200,
                  ),
                ),
                Text(
                  "BST",
                  style: TextStyle(
                    color: isSelected ? widget.accentColor.withOpacity(0.4) : Colors.white10,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // 弹出选择面板
  Widget _buildSheetHeader(bool isA) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF15171A),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isA ? "DATA ANALYSIS / SOURCE A" : "DATA ANALYSIS / SOURCE B",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "SYSTEM READY / SEARCH ENABLED",
                style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 8, letterSpacing: 0.5),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white24, size: 24),
          )
        ],
      ),
    );
  }



}