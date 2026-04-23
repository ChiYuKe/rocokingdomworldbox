import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:convert';
import 'dart:io';

class UpdatePetDataUI extends StatefulWidget {
  final Color accentColor;

  const UpdatePetDataUI({super.key, required this.accentColor});

  @override
  State<UpdatePetDataUI> createState() => _UpdatePetDataUIState();
}

class _UpdatePetDataUIState extends State<UpdatePetDataUI> {
  bool _isLoading = false;
  String _statusMessage = "准备就绪";

  List<Map<String, dynamic>> _petList = [];

  String getOriginalImage(String thumbUrl) {
    if (!thumbUrl.contains('/thumb/')) return thumbUrl;

    final parts = thumbUrl.split('/thumb/');
    final prefix = parts[0];
    final rest = parts[1];

    final realPath = rest.substring(0, rest.lastIndexOf('/'));

    return '$prefix/$realPath';
  }

  Future<void> _fetchWikiData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "正在解析精灵数据...";
    });

    try {
      final response = await http.get(
        Uri.parse('https://wiki.biligame.com/rocom/精灵图鉴'),
        headers: {'User-Agent': 'Mozilla/5.0'},
      );

      if (response.statusCode == 200) {
        var document = parse(response.body);

        ///抓所有带 title 的 a
        var links = document.querySelectorAll('a[title]');

        List<Map<String, dynamic>> tempPets = [];

        for (var a in links) {
          final title = a.attributes['title'] ?? '';

          if (title.isEmpty) continue;

          ///过滤垃圾
          if (title.contains('编辑') ||
              title.contains('分类') ||
              title.contains('文件') ||
              title.contains('模板')) continue;

          /// 精灵名一般不长
          if (title.length > 6) continue;

          var img = a.querySelector('img');
          String imgSrc = img?.attributes['src'] ?? '';

          if (imgSrc.startsWith('//')) imgSrc = 'https:$imgSrc';

          String originalImg = getOriginalImage(imgSrc);

          tempPets.add({
            "name": title,
            "img_small": imgSrc,
            "img_large": originalImg,
            "link": 'https://wiki.biligame.com${a.attributes['href'] ?? ''}',
          });
        }

        /// 去重
        final unique = <String, Map<String, dynamic>>{};
        for (var p in tempPets) {
          unique[p['name']] = p;
        }

        final result = unique.values.toList();

        /// 排序
        result.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));

        /// 生成 JSON
        String jsonStr = const JsonEncoder.withIndent('  ').convert(result);

        /// 写文件（桌面有效）
        final file = File('pets.json');
        await file.writeAsString(jsonStr);

        setState(() {
          _petList = result;
          _statusMessage = "完成！共 ${result.length} 只精灵，已导出 pets.json";
        });
      } else {
        setState(() => _statusMessage = "请求失败: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _statusMessage = "解析错误: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 顶部状态栏
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _statusMessage,
                  style: TextStyle(color: widget.accentColor),
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                ElevatedButton(
                  onPressed: _fetchWikiData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                  ),
                  child: const Text(
                    "同步数据",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),

        /// 精灵列表
        Expanded(
          child: _petList.isEmpty
              ? const Center(child: Text("暂无数据"))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,        
                    childAspectRatio: 0.75,   //  控制高度
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemCount: _petList.length,
                  
itemBuilder: (context, index) {
  final pet = _petList[index];

  final small = pet['img_small'] ?? '';
  final large = pet['img_large'] ?? '';
  final name = pet['name'] ?? '';

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 3,
          offset: Offset(1, 1),
        ),
      ],
    ),
    child: Column(
      children: [
        /// 图片区域（占主要空间）
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              color: Colors.grey[100],
              child: Image.network(
                large,
                fit: BoxFit.contain,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return small.isNotEmpty
                      ? Image.network(small, fit: BoxFit.contain)
                      : const Center(child: CircularProgressIndicator(strokeWidth: 1));
                },
                errorBuilder: (c, e, s) {
                  return small.isNotEmpty
                      ? Image.network(small, fit: BoxFit.contain)
                      : const Icon(Icons.pets, size: 30);
                },
              ),
            ),
          ),
        ),

        /// 名字区域（压缩）
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          alignment: Alignment.center,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
                ),
        ),
      ],
    );
  }
}