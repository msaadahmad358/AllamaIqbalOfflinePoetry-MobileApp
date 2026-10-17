import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yaml/yaml.dart';

import '../core/theme.dart';
import '../core/helpers.dart';
import '../core/widgets.dart';
import 'detail_screen.dart';

// ==================== FAVORITES ====================
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final favBox = Hive.box('favorites');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(title: 'Saved'),
        Expanded(
          child: ValueListenableBuilder<Box>(
            valueListenable: favBox.listenable(),
            builder: (context, box, _) {
              final all =
                  box.toMap().entries.where((e) => e.value is Map).toList();
              final poems =
                  all.where((e) => (e.value as Map)['type'] == 'poem').toList();
              final verses = all
                  .where((e) => (e.value as Map)['type'] == 'verse')
                  .toList();
              final shown = _tab == 0 ? poems : verses;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: PillTabs(
                      labels: [
                        'Poems  ${poems.length}',
                        'Verses  ${verses.length}',
                      ],
                      selected: _tab,
                      onChanged: (i) => setState(() => _tab = i),
                    ),
                  ),
                  Expanded(
                    child: shown.isEmpty
                        ? const EmptyState(title: 'Nothing saved yet')
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: shown.length,
                            itemBuilder: (context, index) {
                              final entry = shown[index];
                              final item = entry.value as Map;
                              final isPoem = _tab == 0;
                              final poemId =
                                  (isPoem ? item['id'] : item['poemId'])
                                      .toString();
                              final tone =
                                  AppTheme.toneFor(poemId.split('_').first);
                              void open() => Navigator.push(context,
                                  fadeRoute(PoemDetailScreen(poemId: poemId)));
                              final unsave = InkResponse(
                                radius: 22,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  box.delete(entry.key);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(Icons.favorite_rounded,
                                      size: 19, color: tone.bg),
                                ),
                              );
                              return isPoem
                                  ? PoemRow(
                                      title: item['title']?.toString() ??
                                          'Untitled',
                                      color: tone.bg,
                                      trailing: unsave,
                                      onTap: open,
                                    )
                                  : VerseRow(
                                      text: item['text']?.toString() ?? '',
                                      source:
                                          item['poemTitle']?.toString() ?? '',
                                      color: tone.bg,
                                      trailing: unsave,
                                      onTap: open,
                                    );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==================== SEARCH ====================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _results = [];
  final List<Map<String, dynamic>> _poemsIndex = [];
  final Map<String, List<String>> _verseCache = {};
  Timer? _debounce;
  int _token = 0;
  bool _isLoading = true;
  bool _isSearching = false;
  bool _busy = false;
  int _filter = 0; // 0 all, 1 poems, 2 verses

  @override
  void initState() {
    super.initState();
    _buildIndex();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _buildIndex() async {
    try {
      final yamlString =
          await rootBundle.loadString('assets/data/list-of-lists.yaml');
      final lists = (loadYaml(yamlString) as YamlMap)['lists'] as YamlList;

      for (var list in lists) {
        final bookName = TextHelpers.getText(list['name'], 'en');
        final listYaml =
            await rootBundle.loadString('assets/data/lists/${list['id']}.yaml');
        final sections =
            (loadYaml(listYaml) as YamlMap)['sections'] as YamlList;

        for (var section in sections) {
          if (section.containsKey('poems')) {
            for (var poem in (section['poems'] as YamlList)) {
              final poemNameEn = TextHelpers.getText(poem['poemName'], 'en');
              final poemNameUr = TextHelpers.getText(poem['poemName'], 'ur');
              _poemsIndex.add({
                'id': poem['id'].toString(),
                'title': poemNameEn.isNotEmpty ? poemNameEn : poemNameUr,
                'titleUr': poemNameUr,
                'book': bookName,
              });
            }
          }
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<List<String>> _versesOf(String id) async {
    final cached = _verseCache[id];
    if (cached != null) return cached;
    try {
      final folder = id.split('_').first;
      final yamlString =
          await rootBundle.loadString('assets/poems/$folder/$id.yaml');
      final shers = (loadYaml(yamlString) as YamlMap)['sher'] as YamlList;
      return _verseCache[id] = shers
          .map((s) => TextHelpers.getSherText(s['sherContent'], 'ur')
              .replaceAll('|', ' '))
          .toList();
    } catch (_) {
      return _verseCache[id] = [];
    }
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      _token++;
      setState(() {
        _isSearching = false;
        _busy = false;
        _results.clear();
      });
      return;
    }
    setState(() {});
    _debounce = Timer(const Duration(milliseconds: 280), () => _search(query));
  }

  Future<void> _search(String query) async {
    final token = ++_token;
    final clean = TextHelpers.cleanText(query.trim());
    if (clean.isEmpty) return;

    setState(() {
      _isSearching = true;
      _busy = true;
    });
    final results = <Map<String, dynamic>>[];

    if (_filter == 0 || _filter == 1) {
      for (var poem in _poemsIndex) {
        if (TextHelpers.cleanText(poem['title']).contains(clean) ||
            TextHelpers.cleanText(poem['titleUr']).contains(clean)) {
          results.add({
            'type': 'poem',
            'id': poem['id'],
            'title': poem['title'],
            'subtitle': poem['book'],
          });
        }
      }
      if (!mounted || token != _token) return;
      setState(() {
        _results
          ..clear()
          ..addAll(results);
      });
    }

    if ((_filter == 0 || _filter == 2) && results.length < 50) {
      for (var poem in _poemsIndex) {
        final verses = await _versesOf(poem['id']);
        if (!mounted || token != _token) return;
        for (final v in verses) {
          if (TextHelpers.cleanText(v).contains(clean)) {
            results.add({
              'type': 'verse',
              'poemId': poem['id'],
              'poemTitle': poem['title'],
              'text': v.length > 90 ? '${v.substring(0, 90)}…' : v,
            });
            break;
          }
        }
        if (results.length > 100) break;
      }
    }

    if (!mounted || token != _token) return;
    setState(() {
      _busy = false;
      _results
        ..clear()
        ..addAll(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(title: 'Search'),
        if (_isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              style: AppText.urdu(18, height: 1.6),
              cursorColor: AppTheme.accent,
              decoration: InputDecoration(
                hintText: 'Title or verse',
                hintStyle: AppText.sans(15, color: AppTheme.textMuted),
                filled: true,
                fillColor: AppTheme.surface,
                prefixIcon: const Icon(Icons.search_rounded,
                    size: 21, color: AppTheme.textMuted),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 19, color: AppTheme.textMuted),
                        onPressed: () {
                          _controller.clear();
                          _onChanged('');
                        },
                      ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: AppTheme.accent, width: 1.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
            child: PillTabs(
              labels: const ['All', 'Poems', 'Verses'],
              selected: _filter,
              onChanged: (i) {
                setState(() => _filter = i);
                if (_controller.text.trim().isNotEmpty) {
                  _search(_controller.text);
                }
              },
            ),
          ),
          SizedBox(
            height: 2,
            child: _busy ? const LinearProgressIndicator(minHeight: 1.5) : null,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: !_isSearching
                ? const SizedBox.shrink()
                : _results.isEmpty && !_busy
                    ? const EmptyState(title: 'No results')
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final r = _results[index];
                          final isPoem = r['type'] == 'poem';
                          final poemId = isPoem ? r['id'] : r['poemId'];
                          final tone = AppTheme.toneFor(
                              poemId.toString().split('_').first);
                          void open() => Navigator.push(context,
                              fadeRoute(PoemDetailScreen(poemId: poemId)));
                          return isPoem
                              ? PoemRow(
                                  title: r['title'],
                                  subtitle: r['subtitle'],
                                  color: tone.bg,
                                  onTap: open)
                              : VerseRow(
                                  text: r['text'],
                                  source: r['poemTitle'],
                                  color: tone.bg,
                                  onTap: open);
                        },
                      ),
          ),
        ],
      ],
    );
  }
}

// ==================== ROW WIDGETS ====================
class _Tile extends StatelessWidget {
  final Color color;
  final Widget child;
  final Widget? trailing;
  final VoidCallback onTap;
  const _Tile({
    required this.color,
    required this.child,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
      child: Material(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(18, 18, trailing == null ? 20 : 8, 18),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: child),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditorialRow extends StatelessWidget {
  final String urdu;
  final String english;
  final Color color;
  final VoidCallback onTap;
  const EditorialRow({
    super.key,
    required this.urdu,
    required this.english,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Tile(
      color: color,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(english,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(13.5, color: AppTheme.textSecondary)),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Text(
              urdu,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppText.urdu(22, height: 1.9),
            ),
          ),
        ],
      ),
    );
  }
}

class PoemRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color color;
  final Widget? trailing;
  final VoidCallback onTap;
  const PoemRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.color,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Tile(
      color: color,
      onTap: onTap,
      trailing: trailing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoText(title, urduSize: 21, latinSize: 15.5, maxLines: 2),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 4),
            AutoText(subtitle!,
                urduSize: 14,
                latinSize: 12,
                color: AppTheme.textMuted,
                maxLines: 1,
                urduHeight: 1.7),
          ],
        ],
      ),
    );
  }
}

class VerseRow extends StatelessWidget {
  final String text;
  final String source;
  final Color color;
  final Widget? trailing;
  final VoidCallback onTap;
  const VerseRow({
    super.key,
    required this.text,
    required this.source,
    required this.color,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Tile(
      color: color,
      onTap: onTap,
      trailing: trailing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppText.urdu(21, height: 2.0),
          ),
          if (source.isNotEmpty) ...[
            const SizedBox(height: 6),
            AutoText(source,
                urduSize: 14,
                latinSize: 12,
                color: AppTheme.textMuted,
                maxLines: 1,
                urduHeight: 1.7),
          ],
        ],
      ),
    );
  }
}
