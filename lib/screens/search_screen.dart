import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yaml/yaml.dart';
import '../config/theme_config.dart';
import '../utils/text_helpers.dart';
import 'poem_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _results = [];
  final List<Map<String, dynamic>> _poemsIndex = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _buildIndex();
  }

  Future<void> _buildIndex() async {
    try {
      final yamlString =
          await rootBundle.loadString('assets/data/list-of-lists.yaml');
      final lists = (loadYaml(yamlString) as YamlMap)['lists'] as YamlList;

      for (var list in lists) {
        final bookName = TextHelpers.getText(list['name'], 'ur');
        final listYaml =
            await rootBundle.loadString('assets/data/lists/${list['id']}.yaml');
        final sections =
            (loadYaml(listYaml) as YamlMap)['sections'] as YamlList;

        for (var section in sections) {
          if (section.containsKey('poems')) {
            for (var poem in (section['poems'] as YamlList)) {
              final poemId = poem['id'].toString();
              final poemName = TextHelpers.getText(poem['poemName'], 'ur');
              _poemsIndex
                  .add({'id': poemId, 'title': poemName, 'book': bookName});
            }
          }
        }
      }
    } catch (e) {}
    setState(() => _isLoading = false);
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _results.clear();
      });
      return;
    }

    setState(() => _isSearching = true);
    final cleanQuery = TextHelpers.cleanText(query);
    final results = <Map<String, dynamic>>[];

    if (_filter == 'all' || _filter == 'poems') {
      for (var poem in _poemsIndex) {
        if (TextHelpers.cleanText(poem['title']).contains(cleanQuery)) {
          results.add({
            'type': 'poem',
            'id': poem['id'],
            'title': poem['title'],
            'subtitle': poem['book']
          });
        }
      }
    }

    if ((_filter == 'all' || _filter == 'verses') && results.length < 50) {
      for (var poem in _poemsIndex) {
        try {
          final folder = poem['id'].split('_').first;
          final yamlString = await rootBundle
              .loadString('assets/poems/$folder/${poem['id']}.yaml');
          final shers = (loadYaml(yamlString) as YamlMap)['sher'] as YamlList;

          for (var sher in shers) {
            final urText = TextHelpers.getSherText(sher['sherContent'], 'ur');
            if (TextHelpers.cleanText(urText).contains(cleanQuery)) {
              results.add({
                'type': 'verse',
                'poemId': poem['id'],
                'poemTitle': poem['title'],
                'text': urText.length > 80
                    ? '${urText.substring(0, 80)}...'
                    : urText,
              });
              break;
            }
          }
        } catch (e) {}
        if (results.length > 100) break;
      }
    }

    setState(() {
      _results.clear();
      _results.addAll(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 100,
          title: Image.asset(
            'assets/images/icon.png',
            height: 100,
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor))
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _controller,
                      onChanged: _search,
                      autofocus: true,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                          hintText: 'شعر یا غزل تلاش کریں...',
                          hintStyle: GoogleFonts.notoNastaliqUrdu(),
                          prefixIcon: const Icon(Icons.search,
                              color: AppTheme.darkColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppTheme.primaryColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildFilterChip('سب', 'all'),
                        const SizedBox(width: 8),
                        _buildFilterChip('غزلیں', 'poems'),
                        const SizedBox(width: 8),
                        _buildFilterChip('اشعار', 'verses'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _isSearching
                        ? _results.isEmpty
                            ? Center(
                                child: Text('کوئی نتیجہ نہیں',
                                    style: GoogleFonts.notoNastaliqUrdu(
                                        color: AppTheme.primaryColor
                                            .withValues(alpha: 0.7))))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _results.length,
                                itemBuilder: (context, index) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: AppTheme.primaryColor),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    title: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                          _results[index]['type'] == 'poem'
                                              ? _results[index]['title']
                                              : _results[index]['text'],
                                          style: GoogleFonts.notoNastaliqUrdu(
                                              fontSize: 16,
                                              color: AppTheme.primaryColor)),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, top: 12),
                                      child: Text(
                                          _results[index]['type'] == 'poem'
                                              ? _results[index]['subtitle']
                                              : _results[index]['poemTitle'],
                                          style: GoogleFonts.notoNastaliqUrdu(
                                              fontSize: 14,
                                              color: AppTheme.primaryColor
                                                  .withValues(alpha: 0.5))),
                                    ),
                                    trailing: const Icon(Icons.chevron_right,
                                        color: AppTheme.primaryColor),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PoemDetailScreen(
                                                  poemId: _results[index]
                                                              ['type'] ==
                                                          'poem'
                                                      ? _results[index]['id']
                                                      : _results[index]
                                                          ['poemId'],
                                                ))),
                                  ),
                                ),
                              )
                        : Center(
                            child: Text('تلاش شروع کریں',
                                style: GoogleFonts.notoNastaliqUrdu(
                                    color: AppTheme.primaryColor))),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Expanded(
      child: FilterChip(
        label:
            Center(child: Text(label, style: GoogleFonts.notoNastaliqUrdu())),
        selected: _filter == value,
        onSelected: (s) {
          setState(() => _filter = value);
          _search(_controller.text);
        },
        backgroundColor: AppTheme.darkColor,
        selectedColor: AppTheme.primaryColor,
        side: BorderSide(
          color: _filter == value ? AppTheme.darkColor : AppTheme.primaryColor,
          width: 0.5,
        ),
        labelStyle: TextStyle(
            color:
                _filter == value ? AppTheme.darkColor : AppTheme.primaryColor),
      ),
    );
  }
}
