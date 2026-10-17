import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/theme.dart';
import '../core/helpers.dart';
import '../core/widgets.dart';
import '../main.dart'; // For iconsFor

// ==================== POEM LIST ====================
class PoemListScreen extends StatefulWidget {
  final String bookId;
  final String bookName;
  final String bookNameEn;
  final BookTone tone;
  const PoemListScreen({
    super.key,
    required this.bookId,
    required this.bookName,
    required this.tone,
    this.bookNameEn = '',
  });

  @override
  State<PoemListScreen> createState() => _PoemListScreenState();
}

class _PoemListScreenState extends State<PoemListScreen> {
  List<Map<String, dynamic>> poems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPoems();
  }

  Future<void> _loadPoems() async {
    try {
      final yamlString = await rootBundle
          .loadString('assets/data/lists/${widget.bookId}.yaml');
      final sections =
          (loadYaml(yamlString) as YamlMap)['sections'] as YamlList;

      for (var section in sections) {
        if (section.containsKey('poems')) {
          for (var poem in (section['poems'] as YamlList)) {
            poems.add({
              'id': poem['id'].toString(),
              'nameUr': TextHelpers.getText(poem['poemName'], 'ur'),
              'nameEn': TextHelpers.getText(poem['poemName'], 'en'),
            });
          }
        }
      }
    } catch (_) {}
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tone;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: iconsFor(t),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: t.bg,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  TopBar(color: t.fg),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 4, 28, 36),
                    child: Column(
                      children: [
                        Text(widget.bookName,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: AppText.urdu(40, color: t.fg, height: 1.7)),
                        if (widget.bookNameEn.isNotEmpty)
                          Text(widget.bookNameEn,
                              textAlign: TextAlign.center,
                              style: AppText.serif(15,
                                  color: t.fg.withOpacity(0.78),
                                  style: FontStyle.italic)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 28, 0, 40),
                      itemCount: poems.length,
                      itemBuilder: (context, index) {
                        final p = poems[index];
                        return EditorialRow(
                          urdu: p['nameUr'],
                          english: p['nameEn'],
                          color: t.bg,
                          onTap: () => Navigator.push(context,
                              fadeRoute(PoemDetailScreen(poemId: p['id']))),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== POEM DETAIL ====================
class PoemDetailScreen extends StatefulWidget {
  final String poemId;
  const PoemDetailScreen({super.key, required this.poemId});

  @override
  State<PoemDetailScreen> createState() => _PoemDetailScreenState();
}

class _PoemDetailScreenState extends State<PoemDetailScreen> {
  late final Box favoritesBox;
  late final BookTone tone;
  bool isLoading = true;
  String headingUr = '';
  String headingEn = '';
  String description = '';
  List<Map<String, dynamic>> shers = [];
  bool poemFavorite = false;
  final Set<int> _openTranslations = {};
  bool _descriptionExpanded = false;
  double _fontScale = 1.0;

  String get _title => headingEn.isNotEmpty ? headingEn : headingUr;

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box('favorites');
    tone = AppTheme.toneFor(widget.poemId.split('_').first);
    _loadScale();
    _loadPoem();
  }

  Future<void> _loadScale() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getDouble('font_scale');
    if (s != null && mounted) setState(() => _fontScale = s);
  }

  Future<void> _loadPoem() async {
    try {
      final folder = widget.poemId.split('_').first;
      final yamlString = await rootBundle
          .loadString('assets/poems/$folder/${widget.poemId}.yaml');
      final yamlMap = loadYaml(yamlString);

      final shersList = yamlMap['sher'];
      if (shersList == null) {
        if (mounted) setState(() => isLoading = false);
        return;
      }

      shers = (shersList as YamlList).map<Map<String, dynamic>>((sher) {
        final id = sher['id']?.toString() ?? '';
        return {
          'id': id,
          'ur': TextHelpers.getSherText(sher['sherContent'], 'ur')
              .replaceAll('|', '\n'),
          'en': TextHelpers.getSherText(sher['sherContent'], 'en'),
          'isFavorite': favoritesBox.containsKey(id),
        };
      }).toList();

      headingUr = TextHelpers.getText(yamlMap['heading'], 'ur');
      headingEn = TextHelpers.getText(yamlMap['heading'], 'en');
      description = yamlMap['description'] != null
          ? TextHelpers.getText(yamlMap['description'], 'en')
          : '';
      poemFavorite = favoritesBox.containsKey(widget.poemId);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_poem_id', widget.poemId);
      await prefs.setString('last_poem_title', _title);
      lastReadNotifier.value = {'id': widget.poemId, 'title': _title};

      if (mounted) setState(() => isLoading = false);
    } catch (_) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _togglePoemFavorite() {
    setState(() {
      if (favoritesBox.containsKey(widget.poemId)) {
        favoritesBox.delete(widget.poemId);
        poemFavorite = false;
      } else {
        favoritesBox.put(widget.poemId, {
          'type': 'poem',
          'id': widget.poemId,
          'title': _title,
        });
        poemFavorite = true;
      }
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleVerseFavorite(int index) {
    final sher = shers[index];
    final id = sher['id'] as String;
    setState(() {
      if (favoritesBox.containsKey(id)) {
        favoritesBox.delete(id);
        sher['isFavorite'] = false;
      } else {
        favoritesBox.put(id, {
          'type': 'verse',
          'poemId': widget.poemId,
          'poemTitle': _title,
          'text': sher['ur'],
        });
        sher['isFavorite'] = true;
      }
    });
    HapticFeedback.lightImpact();
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Copied'), duration: Duration(seconds: 1)));
  }

  void _toggleTranslation(int index) {
    setState(() {
      if (!_openTranslations.add(index)) _openTranslations.remove(index);
    });
  }

  void _showSizeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  headingUr.isNotEmpty ? headingUr : 'خودی',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.urdu(23 * _fontScale, height: 2.0),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text('A', style: AppText.serif(13)),
                    Expanded(
                      child: Slider(
                        value: _fontScale,
                        min: 0.85,
                        max: 1.45,
                        divisions: 6,
                        activeColor: tone.bg,
                        inactiveColor: tone.bg.withOpacity(0.2),
                        onChanged: (v) {
                          setSheet(() {});
                          setState(() => _fontScale = v);
                        },
                        onChangeEnd: (v) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setDouble('font_scale', v);
                        },
                      ),
                    ),
                    Text('A', style: AppText.serif(24)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLong = description.length > 180;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: iconsFor(tone),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Column(
          children: [
            Container(
              color: tone.bg,
              child: TopBar(color: tone.fg, actions: [
                IconButton(
                  icon:
                      Icon(Icons.text_fields_rounded, size: 22, color: tone.fg),
                  onPressed: _showSizeSheet,
                ),
                IconButton(
                  icon: Icon(
                    poemFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 21,
                    color: tone.fg,
                  ),
                  onPressed: isLoading ? null : _togglePoemFavorite,
                ),
              ]),
            ),
            Expanded(
              child: isLoading
                  ? Align(
                      alignment: const Alignment(0, -0.3),
                      child: const CircularProgressIndicator(),
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(28, 4, 28, 40),
                          decoration: BoxDecoration(
                            color: tone.bg,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(32)),
                          ),
                          child: Column(
                            children: [
                              if (headingUr.isNotEmpty)
                                Text(headingUr,
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    style: AppText.urdu(36 * _fontScale,
                                        color: tone.fg, height: 1.8)),
                              if (headingEn.isNotEmpty)
                                Text(headingEn,
                                    textAlign: TextAlign.center,
                                    style: AppText.serif(15,
                                        color: tone.fg.withOpacity(0.8),
                                        style: FontStyle.italic)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        if (description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 0, 32, 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    description,
                                    maxLines: _descriptionExpanded ? null : 4,
                                    overflow: _descriptionExpanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                    style: AppText.serif(14.5,
                                        color: AppTheme.textSecondary,
                                        height: 1.8),
                                  ),
                                ),
                                if (isLong)
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(() =>
                                        _descriptionExpanded =
                                            !_descriptionExpanded),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        _descriptionExpanded ? 'Less' : 'More',
                                        style: AppText.sans(13,
                                            weight: FontWeight.w600,
                                            color: tone.hasLightText
                                                ? tone.bg
                                                : AppTheme.textPrimary),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                          child: Column(
                            children: [
                              for (int i = 0; i < shers.length; i++)
                                SherCardWidget(
                                  index: i,
                                  urText: shers[i]['ur'],
                                  enText: shers[i]['en'],
                                  isFavorite: shers[i]['isFavorite'] == true,
                                  showTranslation:
                                      _openTranslations.contains(i),
                                  fontScale: _fontScale,
                                  color: tone.bg,
                                  onToggleFavorite: () =>
                                      _toggleVerseFavorite(i),
                                  onToggleTranslation: () =>
                                      _toggleTranslation(i),
                                  onCopy: () => _copyText(shers[i]['ur']),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SHER CARD ====================
class SherCardWidget extends StatelessWidget {
  final int index;
  final String urText;
  final String enText;
  final bool isFavorite;
  final bool showTranslation;
  final double fontScale;
  final Color color;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleTranslation;
  final VoidCallback onCopy;

  const SherCardWidget({
    super.key,
    required this.index,
    required this.urText,
    required this.enText,
    required this.isFavorite,
    required this.showTranslation,
    required this.onToggleFavorite,
    required this.onToggleTranslation,
    required this.onCopy,
    required this.color,
    this.fontScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final hasTranslation = enText.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: hasTranslation ? onToggleTranslation : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (hasTranslation)
                      _iconBtn(
                          Icons.translate_rounded,
                          showTranslation ? color : AppTheme.textMuted,
                          onToggleTranslation),
                    _iconBtn(Icons.copy_rounded, AppTheme.textMuted, onCopy),
                    _iconBtn(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      isFavorite ? color : AppTheme.textMuted,
                      onToggleFavorite,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  urText,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: AppText.urdu(23 * fontScale, height: 2.3),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: showTranslation && hasTranslation
                      ? Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 18),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            enText,
                            textAlign: TextAlign.center,
                            style: AppText.serif(15,
                                color: AppTheme.textPrimary,
                                style: FontStyle.italic,
                                height: 1.7),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Icon(icon, size: 19, color: color),
      ),
    );
  }
}
