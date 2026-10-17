import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

import '../core/theme.dart';
import '../core/helpers.dart';
import '../core/widgets.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadBooks();
    await _loadLastRead();
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _loadBooks() async {
    try {
      final yamlString =
          await rootBundle.loadString('assets/data/list-of-lists.yaml');
      final lists = (loadYaml(yamlString) as YamlMap)['lists'] as YamlList;
      books = lists
          .map((list) => {
                'id': list['id'].toString(),
                'nameUr': TextHelpers.getText(list['name'], 'ur'),
                'nameEn': TextHelpers.getText(list['name'], 'en'),
              })
          .toList();
    } catch (_) {}
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('last_poem_id');
    if (id != null) {
      lastReadNotifier.value = {
        'id': id,
        'title': prefs.getString('last_poem_title') ?? '',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(context),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ValueListenableBuilder<Map<String, String>?>(
                        valueListenable: lastReadNotifier,
                        builder: (context, last, _) => last == null
                            ? const SizedBox.shrink()
                            : _continueCard(context, last),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 22,
                          crossAxisSpacing: 22,
                          childAspectRatio: 0.78,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final b = books[i];
                            final tone = AppTheme.toneFor(b['id'], i);
                            return BookTile(
                              urdu: b['nameUr'],
                              english: b['nameEn'],
                              tone: tone,
                              onTap: () => Navigator.push(
                                context,
                                fadeRoute(PoemListScreen(
                                  bookId: b['id'],
                                  bookName: b['nameUr'],
                                  bookNameEn: b['nameEn'],
                                  tone: tone,
                                )),
                              ),
                            );
                          },
                          childCount: books.length,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 22, 12, 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('علامہ محمد اقبال',
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.rtl,
                      style: AppText.urdu(40, height: 1.6)),
                  Text('Offline poetry',
                      style: AppText.sans(13.5, color: AppTheme.textMuted)),
                ],
              ),
            ),
            const BrandMark(size: 48),
            IconButton(
              icon: const Icon(Icons.info_outline_rounded,
                  size: 21, color: AppTheme.textSecondary),
              onPressed: () => CommonWidgets.showInfoDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _continueCard(BuildContext context, Map<String, String> last) {
    final tone = AppTheme.toneFor(last['id']!.split('_').first);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Material(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => Navigator.push(
              context, fadeRoute(PoemDetailScreen(poemId: last['id']!))),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: tone.bg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward_rounded,
                      size: 20, color: tone.fg),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Continue reading',
                          style: AppText.sans(12, color: AppTheme.textMuted)),
                      const SizedBox(height: 2),
                      AutoText(last['title'] ?? '',
                          urduSize: 20, latinSize: 15, maxLines: 1),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
