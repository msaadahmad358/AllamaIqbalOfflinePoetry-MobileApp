import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yaml/yaml.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/theme_config.dart';
import '../utils/text_helpers.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sher_card_widget.dart';

class PoemDetailScreen extends StatefulWidget {
  final String poemId;
  const PoemDetailScreen({super.key, required this.poemId});

  @override
  State<PoemDetailScreen> createState() => _PoemDetailScreenState();
}

class _PoemDetailScreenState extends State<PoemDetailScreen> {
  Map<String, dynamic>? poemData;
  bool isLoading = true;
  late Box favoritesBox;
  bool _showFullDescription = false;
  Map<int, bool> translationVisible = {};

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box('favorites');
    _loadPoem();
    _saveRecent();
  }

  Future<void> _saveRecent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_poem_id', widget.poemId);
  }

  Future<void> _loadPoem() async {
    try {
      final folder = widget.poemId.split('_').first;
      final yamlString = await rootBundle
          .loadString('assets/poems/$folder/${widget.poemId}.yaml');
      final YamlMap yamlMap = loadYaml(yamlString);

      final shersList = yamlMap['sher'];
      if (shersList == null) {
        setState(() => isLoading = false);
        return;
      }

      final shers = (shersList as YamlList)
          .asMap()
          .map((idx, sher) {
            return MapEntry(idx, {
              'id': sher['id']?.toString() ?? '',
              'ur': TextHelpers.getSherText(sher['sherContent'], 'ur')
                  .replaceAll('|', '\n'),
              'en': TextHelpers.getSherText(sher['sherContent'], 'en'),
              'isFavorite': favoritesBox.containsKey(sher['id']?.toString()),
            });
          })
          .values
          .toList();

      poemData = {
        'headingUr': TextHelpers.getText(yamlMap['heading'], 'ur'),
        'description': yamlMap['description'] != null
            ? TextHelpers.getText(yamlMap['description'], 'en')
            : '',
        'shers': shers,
        'isFavorite': favoritesBox.containsKey(widget.poemId),
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_poem_title', poemData!['headingUr']);
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _togglePoemFavorite() {
    setState(() {
      if (favoritesBox.containsKey(widget.poemId)) {
        favoritesBox.delete(widget.poemId);
        poemData!['isFavorite'] = false;
      } else {
        favoritesBox.put(widget.poemId, {
          'type': 'poem',
          'id': widget.poemId,
          'title': poemData!['headingUr']?.toString() ?? 'Untitled'
        });
        poemData!['isFavorite'] = true;
      }
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleVerseFavorite(String id, String text) {
    setState(() {
      if (favoritesBox.containsKey(id)) {
        favoritesBox.delete(id);
        final index = poemData!['shers'].indexWhere((s) => s['id'] == id);
        poemData!['shers'][index]['isFavorite'] = false;
      } else {
        favoritesBox.put(id, {
          'type': 'verse',
          'poemId': widget.poemId,
          'poemTitle': poemData!['headingUr']?.toString() ?? 'Unknown',
          'text': text
        });
        final index = poemData!['shers'].indexWhere((s) => s['id'] == id);
        poemData!['shers'][index]['isFavorite'] = true;
      }
    });
    HapticFeedback.lightImpact();
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('کاپی ہو گیا'), duration: Duration(seconds: 1)));
  }

  void _toggleTranslation(int index) {
    setState(() {
      translationVisible[index] = !(translationVisible[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkColor,
      appBar: AppBar(
        title: Text(poemData?['headingUr'] ?? 'شعر',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoNastaliqUrdu(color: AppTheme.primaryColor)),
        leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
            onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(
                poemData?['isFavorite'] == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: AppTheme.primaryColor),
            onPressed: _togglePoemFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppTheme.primaryColor),
            onPressed: () => CommonWidgets.showInfoDialog(context),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (poemData!['description'].isNotEmpty)
                    _buildExpandableDescription(),
                  ...poemData!['shers'].asMap().entries.map((entry) {
                    final index = entry.key;
                    final sher = entry.value;
                    final showTranslation = translationVisible[index] ?? false;
                    return SherCardWidget(
                      index: index,
                      urText: sher['ur'],
                      enText: sher['en'],
                      isFavorite: sher['isFavorite'],
                      showTranslation: showTranslation,
                      onToggleFavorite: () =>
                          _toggleVerseFavorite(sher['id'], sher['ur']),
                      onToggleTranslation: () => _toggleTranslation(index),
                      onCopy: () => _copyText(sher['ur']),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildExpandableDescription() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showFullDescription = !_showFullDescription;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          // color: Colors.white.withValues(alpha:0.85),
          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  _showFullDescription
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                Text('تعارف',
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                    )),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _showFullDescription
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Text(
                poemData!['description'],
                style: GoogleFonts.poppins(
                    fontSize: 12, height: 1.4, color: Colors.white),
                textAlign: TextAlign.left,
              ),
              secondChild: Text(
                poemData!['description'].length > 100
                    ? '${poemData!['description'].substring(0, 100)}...'
                    : poemData!['description'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  height: 1.6,
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
