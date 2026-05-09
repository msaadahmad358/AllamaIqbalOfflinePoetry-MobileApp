import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yaml/yaml.dart';
import '../config/theme_config.dart';
import '../utils/text_helpers.dart';
import '../widgets/common_widgets.dart';
import 'poem_detail_screen.dart';

class PoemListScreen extends StatefulWidget {
  final String bookId;
  final String bookName;
  const PoemListScreen(
      {super.key, required this.bookId, required this.bookName});

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
      final YamlMap yamlMap = loadYaml(yamlString);
      final sections = yamlMap['sections'] as YamlList;

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
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkColor,
      appBar: AppBar(
        title: Text(widget.bookName,
            style: GoogleFonts.notoNastaliqUrdu(color: AppTheme.primaryColor)),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppTheme.primaryColor,
            ),
            onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: AppTheme.primaryColor,
            ),
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
          : Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: poems.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: AppTheme.accentColor.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4)
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),

                    title: Text(poems[index]['nameUr'],
                        style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 20, color: AppTheme.darkColor)),
                    // subtitle: Text(poems[index]['nameEn'],
                    //     style: GoogleFonts.notoNastaliqUrdu(
                    //         fontSize: 12,
                    //         color: AppTheme.secondaryColor.withValues(alpha:0.7))),
                    trailing: const Icon(Icons.chevron_right,
                        color: AppTheme.darkColor),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                PoemDetailScreen(poemId: poems[index]['id']))),
                  ),
                ),
              ),
            ),
    );
  }
}
