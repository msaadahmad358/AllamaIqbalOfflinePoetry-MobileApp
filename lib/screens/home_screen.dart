import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yaml/yaml.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme_config.dart';
import '../utils/text_helpers.dart';
import '../widgets/common_widgets.dart';
import '../widgets/book_card_widget.dart';
import 'poem_detail_screen.dart';
import 'poem_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> books = [];
  Map<String, dynamic>? lastRead;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadBooks();
    await _loadLastRead();
    setState(() => isLoading = false);
  }

  Future<void> _loadBooks() async {
    try {
      final yamlString =
          await rootBundle.loadString('assets/data/list-of-lists.yaml');
      final YamlMap yamlMap = loadYaml(yamlString);
      final lists = yamlMap['lists'] as YamlList;
      books = lists
          .map((list) => {
                'id': list['id'],
                'nameUr': TextHelpers.getText(list['name'], 'ur'),
                'nameEn': TextHelpers.getText(list['name'], 'en'),
              })
          .toList();
    } catch (e) {}
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('last_poem_id');
    if (id != null) {
      lastRead = {'id': id, 'title': prefs.getString('last_poem_title') ?? ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Image.asset(
          'assets/images/icon.png',
          height: 100,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: AppTheme.darkColor,
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
              child: Column(
                children: [
                  if (lastRead != null) _buildContinueCard(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: books.length,
                      itemBuilder: (context, index) => BookCardWidget(
                        nameUr: books[index]['nameUr'],
                        nameEn: books[index]['nameEn'],
                        index: index,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PoemListScreen(
                                    bookId: books[index]['id'],
                                    bookName: books[index]['nameUr']))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildContinueCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: const Icon(
          Icons.history,
          color: AppTheme.primaryColor,
          size: 32,
        ),
        title: Text('پڑھنا جاری رکھیں',
            style: GoogleFonts.notoNastaliqUrdu(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            )),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(lastRead!['title'],
              style: GoogleFonts.notoNastaliqUrdu(
                color: AppTheme.primaryColor,
              )),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.primaryColor,
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PoemDetailScreen(poemId: lastRead!['id']))),
      ),
    );
  }
}
