import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:iqbal_app/screens/splash_screen.dart';
import 'config/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await Hive.openBox('recent');

  runApp(
    DevicePreview(
      enabled: false, // Set to false for production

      builder: (context) => const IqbalPoetryApp(),
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

class IqbalPoetryApp extends StatelessWidget {
  const IqbalPoetryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      title: 'Iqbal Demystified',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const SplashScreen(),
      builder: DevicePreview.appBuilder, // Add this line
    );
  }
}
//     setState(() => isLoading = false);
//   }

//   Future<void> _loadBooks() async {
//     try {
//       final yamlString =
//           await rootBundle.loadString('assets/data/list-of-lists.yaml');
//       final YamlMap yamlMap = loadYaml(yamlString);
//       final lists = yamlMap['lists'] as YamlList;
//       books = lists
//           .map((list) => {
//                 'id': list['id'],
//                 'nameUr': _getText(list['name'], 'ur'),
//                 'nameEn': _getText(list['name'], 'en'),
//               })
//           .toList();
//     } catch (e) {}
//   }

//   Future<void> _loadLastRead() async {
//     final prefs = await SharedPreferences.getInstance();
//     final id = prefs.getString('last_poem_id');
//     if (id != null) {
//       lastRead = {'id': id, 'title': prefs.getString('last_poem_title') ?? ''};
//     }
//   }

//   String _getText(dynamic list, String lang) {
//     final names = list as YamlList;
//     return names.firstWhere((n) => n['lang'] == lang)['text'] ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text(
//             'کلیات اقبال',
//             style: GoogleFonts.notoNastaliqUrdu(),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.info_outline),
//               onPressed: () => _showInfoDialog(context),
//             ),
//           ],
//         ),
//         body: isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: Color(0xFFC3601F)))
//             : Column(
//                 children: [
//                   if (lastRead != null) _buildContinueCard(),
//                   Expanded(
//                     child: ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: books.length,
//                       itemBuilder: (context, index) =>
//                           _buildBookCard(books[index], index),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _showInfoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: borderRadius.circular(24)),
//           title: Text('اقبال ڈیمیسٹیفائیڈ',
//               style: GoogleFonts.notoNastaliqUrdu(
//                   color: const Color(0xFFC3601F), fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('علامہ اقبال کی شاعری کا مجموعہ',
//                   style: GoogleFonts.notoNastaliqUrdu(fontSize: 14)),
//               const SizedBox(height: 12),
//               const Divider(),
//               _buildInfoRow('ورژن', '1.0.0'),
//               _buildInfoRow('غزلیں', '500+'),
//               _buildInfoRow('کتابیں', '11'),
//               const SizedBox(height: 12),
//               const Divider(),
//               Text('رازداری کی پالیسی',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       fontWeight: FontWeight.bold, fontSize: 13)),
//               const SizedBox(height: 4),
//               Text(
//                   'آپ کا ڈیٹا مقامی طور پر محفوظ ہے۔ کوئی ذاتی معلومات جمع نہیں کی جاتی۔',
//                   style: GoogleFonts.poppins(
//                       fontSize: 11, color: Colors.grey[600])),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('بند کریں',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       color: const Color(0xFFC3601F))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: GoogleFonts.notoNastaliqUrdu(fontSize: 13)),
//           Text(value,
//               style: GoogleFonts.poppins(
//                   fontSize: 13, color: const Color(0xFF80461B))),
//         ],
//       ),
//     );
//   }

//   Widget _buildContinueCard() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [const Color(0xFFC3601F), const Color(0xFFD1B46D)],
//         ),
//         borderRadius: borderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//               color: const Color(0xFFC3601F).withValues(alpha:0.3), blurRadius: 10)
//         ],
//       ),
//       child: ListTile(
//         leading: const Icon(Icons.history, color: Colors.white),
//         title: Text('پڑھنا جاری رکھیں',
//             style: GoogleFonts.notoNastaliqUrdu(
//                 fontWeight: FontWeight.w600, color: Colors.white)),
//         subtitle: Text(lastRead!['title'],
//             style: GoogleFonts.notoNastaliqUrdu(color: Colors.white70)),
//         trailing: const Icon(Icons.arrow_forward, color: Colors.white),
//         onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => PoemDetailScreen(poemId: lastRead!['id']))),
//       ),
//     );
//   }

//   Widget _buildBookCard(Map<String, dynamic> book, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha:0.9),
//         borderRadius: borderRadius.circular(24),
//         border: Border.all(
//             color: const Color(0xFFD1B46D).withValues(alpha:0.3), width: 0.5),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withValues(alpha:0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2))
//         ],
//       ),
//       child: ListTile(
//         leading: Container(
//           width: 44,
//           height: 44,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [const Color(0xFFC3601F), const Color(0xFFD1B46D)]),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Center(
//               child: Text('${index + 1}',
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.white))),
//         ),
//         title: Text(book['nameUr'],
//             style: GoogleFonts.notoNastaliqUrdu(
//                 fontWeight: FontWeight.w500, fontSize: 16)),
//         subtitle: Text(book['nameEn'],
//             style: GoogleFonts.notoNastaliqUrdu(
//                 fontSize: 13, color: const Color(0xFF80461B).withValues(alpha:0.7))),
//         trailing: const Icon(Icons.chevron_right, color: Color(0xFFC3601F)),
//         onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => PoemListScreen(
//                     bookId: book['id'], bookName: book['nameUr']))),
//       ),
//     );
//   }
// }

// class PoemListScreen extends StatefulWidget {
//   final String bookId;
//   final String bookName;
//   const PoemListScreen(
//       {super.key, required this.bookId, required this.bookName});

//   @override
//   State<PoemListScreen> createState() => _PoemListScreenState();
// }

// class _PoemListScreenState extends State<PoemListScreen> {
//   List<Map<String, dynamic>> poems = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadPoems();
//   }

//   Future<void> _loadPoems() async {
//     try {
//       final yamlString = await rootBundle
//           .loadString('assets/data/lists/${widget.bookId}.yaml');
//       final YamlMap yamlMap = loadYaml(yamlString);
//       final sections = yamlMap['sections'] as YamlList;

//       for (var section in sections) {
//         if (section.containsKey('poems')) {
//           for (var poem in (section['poems'] as YamlList)) {
//             poems.add({
//               'id': poem['id'].toString(),
//               'nameUr': _getText(poem['poemName'], 'ur'),
//               'nameEn': _getText(poem['poemName'], 'en'),
//             });
//           }
//         }
//       }
//       setState(() => isLoading = false);
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }

//   String _getText(dynamic list, String lang) {
//     final names = list as YamlList;
//     return names.firstWhere((n) => n['lang'] == lang)['text'] ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text(widget.bookName, style: GoogleFonts.notoNastaliqUrdu()),
//           leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => Navigator.pop(context)),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.info_outline),
//               onPressed: () => _showInfoDialog(context),
//             ),
//           ],
//         ),
//         body: isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: Color(0xFFC3601F)))
//             : ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: poems.length,
//                 itemBuilder: (context, index) => Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha:0.9),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                         color: const Color(0xFFD1B46D).withValues(alpha:0.3)),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha:0.02), blurRadius: 4)
//                     ],
//                   ),
//                   child: ListTile(
//                     title: Text(poems[index]['nameUr'],
//                         style: GoogleFonts.notoNastaliqUrdu(fontSize: 15)),
//                     subtitle: Text(poems[index]['nameEn'],
//                         style: GoogleFonts.notoNastaliqUrdu(
//                             fontSize: 12,
//                             color: const Color(0xFF80461B).withValues(alpha:0.7))),
//                     trailing: const Icon(Icons.chevron_right,
//                         color: Color(0xFFC3601F)),
//                     onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 PoemDetailScreen(poemId: poems[index]['id']))),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   void _showInfoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: borderRadius.circular(24)),
//           title: Text('اقبال ڈیمیسٹیفائیڈ',
//               style: GoogleFonts.notoNastaliqUrdu(
//                   color: const Color(0xFFC3601F), fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('علامہ اقبال کی شاعری کا مجموعہ',
//                   style: GoogleFonts.notoNastaliqUrdu(fontSize: 14)),
//               const SizedBox(height: 12),
//               const Divider(),
//               _buildInfoRow('ورژن', '1.0.0'),
//               _buildInfoRow('غزلیں', '500+'),
//               _buildInfoRow('کتابیں', '11'),
//               const SizedBox(height: 12),
//               const Divider(),
//               Text('رازداری کی پالیسی',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       fontWeight: FontWeight.bold, fontSize: 13)),
//               const SizedBox(height: 4),
//               Text(
//                   'آپ کا ڈیٹا مقامی طور پر محفوظ ہے۔ کوئی ذاتی معلومات جمع نہیں کی جاتی۔',
//                   style: GoogleFonts.poppins(
//                       fontSize: 11, color: Colors.grey[600])),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('بند کریں',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       color: const Color(0xFFC3601F))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: GoogleFonts.notoNastaliqUrdu(fontSize: 13)),
//           Text(value,
//               style: GoogleFonts.poppins(
//                   fontSize: 13, color: const Color(0xFF80461B))),
//         ],
//       ),
//     );
//   }
// }

// class PoemDetailScreen extends StatefulWidget {
//   final String poemId;
//   const PoemDetailScreen({super.key, required this.poemId});

//   @override
//   State<PoemDetailScreen> createState() => _PoemDetailScreenState();
// }

// class _PoemDetailScreenState extends State<PoemDetailScreen> {
//   Map<String, dynamic>? poemData;
//   bool isLoading = true;
//   late Box favoritesBox;
//   bool _showFullDescription = false;
//   Map<int, bool> translationVisible = {};

//   @override
//   void initState() {
//     super.initState();
//     favoritesBox = Hive.box('favorites');
//     _loadPoem();
//     _saveRecent();
//   }

//   Future<void> _saveRecent() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('last_poem_id', widget.poemId);
//   }

//   Future<void> _loadPoem() async {
//     try {
//       final folder = widget.poemId.split('_').first;
//       final yamlString = await rootBundle
//           .loadString('assets/poems/$folder/${widget.poemId}.yaml');
//       final YamlMap yamlMap = loadYaml(yamlString);

//       final shersList = yamlMap['sher'];
//       if (shersList == null) {
//         setState(() => isLoading = false);
//         return;
//       }

//       final shers = (shersList as YamlList)
//           .asMap()
//           .map((idx, sher) {
//             return MapEntry(idx, {
//               'id': sher['id']?.toString() ?? '',
//               'ur':
//                   _getSherText(sher['sherContent'], 'ur').replaceAll('|', '\n'),
//               'en': _getSherText(sher['sherContent'], 'en'),
//               'isFavorite': favoritesBox.containsKey(sher['id']?.toString()),
//             });
//           })
//           .values
//           .toList();

//       poemData = {
//         'headingUr': _getText(yamlMap['heading'], 'ur'),
//         'description': yamlMap['description'] != null
//             ? _getText(yamlMap['description'], 'en')
//             : '',
//         'shers': shers,
//         'isFavorite': favoritesBox.containsKey(widget.poemId),
//       };

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('last_poem_title', poemData!['headingUr']);
//       setState(() => isLoading = false);
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }

//   String _getText(dynamic list, String lang) {
//     if (list == null) return '';
//     try {
//       final names = list as YamlList;
//       final result =
//           names.firstWhere((n) => n['lang'] == lang, orElse: () => null);
//       return result?['text']?.toString() ?? '';
//     } catch (e) {
//       return '';
//     }
//   }

//   String _getSherText(dynamic list, String lang) {
//     if (list == null) return '';
//     try {
//       final texts = list as YamlList;
//       final result =
//           texts.firstWhere((n) => n['lang'] == lang, orElse: () => null);
//       return result?['text']?.toString() ?? '';
//     } catch (e) {
//       return '';
//     }
//   }

//   void _togglePoemFavorite() {
//     setState(() {
//       if (favoritesBox.containsKey(widget.poemId)) {
//         favoritesBox.delete(widget.poemId);
//         poemData!['isFavorite'] = false;
//       } else {
//         favoritesBox.put(widget.poemId, {
//           'type': 'poem',
//           'id': widget.poemId,
//           'title': poemData!['headingUr']?.toString() ?? 'Untitled'
//         });
//         poemData!['isFavorite'] = true;
//       }
//     });
//     HapticFeedback.mediumImpact();
//   }

//   void _toggleVerseFavorite(String id, String text) {
//     setState(() {
//       if (favoritesBox.containsKey(id)) {
//         favoritesBox.delete(id);
//         final index = poemData!['shers'].indexWhere((s) => s['id'] == id);
//         poemData!['shers'][index]['isFavorite'] = false;
//       } else {
//         favoritesBox.put(id, {
//           'type': 'verse',
//           'poemId': widget.poemId,
//           'poemTitle': poemData!['headingUr']?.toString() ?? 'Unknown',
//           'text': text
//         });
//         final index = poemData!['shers'].indexWhere((s) => s['id'] == id);
//         poemData!['shers'][index]['isFavorite'] = true;
//       }
//     });
//     HapticFeedback.lightImpact();
//   }

//   void _copyText(String text) {
//     Clipboard.setData(ClipboardData(text: text));
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('کاپی ہو گیا'), duration: Duration(seconds: 1)));
//   }

//   void _toggleTranslation(int index) {
//     setState(() {
//       translationVisible[index] = !(translationVisible[index] ?? false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text(poemData?['headingUr'] ?? 'شعر',
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.notoNastaliqUrdu()),
//           leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => Navigator.pop(context)),
//           actions: [
//             IconButton(
//               icon: Icon(
//                   poemData?['isFavorite'] == true
//                       ? Icons.favorite
//                       : Icons.favorite_border,
//                   color: const Color(0xFFC3601F)),
//               onPressed: _togglePoemFavorite,
//             ),
//             IconButton(
//               icon: const Icon(Icons.info_outline),
//               onPressed: () => _showInfoDialog(context),
//             ),
//           ],
//         ),
//         body: isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: Color(0xFFC3601F)))
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     if (poemData!['description'].isNotEmpty)
//                       _buildExpandableDescription(),
//                     ...poemData!['shers'].asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final sher = entry.value;
//                       final showTranslation =
//                           translationVisible[index] ?? false;
//                       return GestureDetector(
//                         onTap: () => _toggleTranslation(index),
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withValues(alpha:0.85),
//                             borderRadius: borderRadius.circular(24),
//                             border: Border.all(
//                                 color: const Color(0xFFD1B46D).withValues(alpha:0.3),
//                                 width: 0.5),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.black.withValues(alpha:0.05),
//                                   blurRadius: 8)
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(
//                                         sher['isFavorite']
//                                             ? Icons.favorite
//                                             : Icons.favorite_border,
//                                         size: 18,
//                                         color: const Color(0xFFC3601F)),
//                                     onPressed: () => _toggleVerseFavorite(
//                                         sher['id'], sher['ur']),
//                                     padding: EdgeInsets.zero,
//                                     constraints: const BoxConstraints(),
//                                   ),
//                                   Text('${index + 1}',
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: const Color(0xFF80461B)
//                                               .withValues(alpha:0.6))),
//                                 ],
//                               ),
//                               const SizedBox(height: 12),
//                               GestureDetector(
//                                 onLongPress: () => _copyText(sher['ur']),
//                                 child: Text(
//                                   sher['ur'],
//                                   style: GoogleFonts.notoNastaliqUrdu(
//                                       fontSize: 18,
//                                       height: 1.6,
//                                       color: const Color(0xFF2D1304)),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                               if (showTranslation) ...[
//                                 const SizedBox(height: 12),
//                                 Divider(
//                                     color: const Color(0xFFD1B46D)
//                                         .withValues(alpha:0.5)),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   sher['en'],
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       height: 1.4,
//                                       color: const Color(0xFF80461B)),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                               const SizedBox(height: 8),
//                               Text(
//                                 showTranslation
//                                     ? '▲ ترجمہ چھپائیں'
//                                     : '▼ ترجمہ دیکھیں',
//                                 style: GoogleFonts.notoNastaliqUrdu(
//                                     fontSize: 11,
//                                     color: const Color(0xFFC3601F)
//                                         .withValues(alpha:0.7)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildExpandableDescription() {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _showFullDescription = !_showFullDescription;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(alpha:0.85),
//           borderRadius: borderRadius.circular(24),
//           border: Border.all(color: const Color(0xFFD1B46D).withValues(alpha:0.3)),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 8)
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('تعارف',
//                     style: GoogleFonts.notoNastaliqUrdu(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                         color: Color(0xFFC3601F))),
//                 Icon(
//                   _showFullDescription
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: const Color(0xFFC3601F),
//                   size: 20,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             AnimatedCrossFade(
//               duration: const Duration(milliseconds: 300),
//               crossFadeState: _showFullDescription
//                   ? CrossFadeState.showFirst
//                   : CrossFadeState.showSecond,
//               firstChild: Text(
//                 poemData!['description'],
//                 style: GoogleFonts.poppins(
//                     fontSize: 12, height: 1.4, color: const Color(0xFF80461B)),
//                 textAlign: TextAlign.left,
//               ),
//               secondChild: Text(
//                 poemData!['description'].length > 100
//                     ? '${poemData!['description'].substring(0, 100)}...'
//                     : poemData!['description'],
//                 style: GoogleFonts.poppins(
//                     fontSize: 12, height: 1.4, color: const Color(0xFF80461B)),
//                 textAlign: TextAlign.left,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _showInfoDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => Directionality(
//       textDirection: TextDirection.rtl,
//       child: AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: borderRadius.circular(24)),
//         title: Text('اقبال ڈیمیسٹیفائیڈ',
//             style: GoogleFonts.notoNastaliqUrdu(
//                 color: const Color(0xFFC3601F), fontWeight: FontWeight.bold)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('علامہ اقبال کی شاعری کا مجموعہ',
//                 style: GoogleFonts.notoNastaliqUrdu(fontSize: 14)),
//             const SizedBox(height: 12),
//             const Divider(),
//             _buildInfoRow('ورژن', '1.0.0'),
//             _buildInfoRow('غزلیں', '500+'),
//             _buildInfoRow('کتابیں', '11'),
//             const SizedBox(height: 12),
//             const Divider(),
//             Text('رازداری کی پالیسی',
//                 style: GoogleFonts.notoNastaliqUrdu(
//                     fontWeight: FontWeight.bold, fontSize: 13)),
//             const SizedBox(height: 4),
//             Text(
//                 'آپ کا ڈیٹا مقامی طور پر محفوظ ہے۔ کوئی ذاتی معلومات جمع نہیں کی جاتی۔',
//                 style:
//                     GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('بند کریں',
//                 style: GoogleFonts.notoNastaliqUrdu(
//                     color: const Color(0xFFC3601F))),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildInfoRow(String label, String value) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: GoogleFonts.notoNastaliqUrdu(fontSize: 13)),
//         Text(value,
//             style: GoogleFonts.poppins(
//                 fontSize: 13, color: const Color(0xFF80461B))),
//       ],
//     ),
//   );
// }

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, dynamic>> _results = [];
//   final List<Map<String, dynamic>> _poemsIndex = [];
//   bool _isLoading = true;
//   bool _isSearching = false;
//   String _filter = 'all';

//   @override
//   void initState() {
//     super.initState();
//     _buildIndex();
//   }

//   Future<void> _buildIndex() async {
//     try {
//       final yamlString =
//           await rootBundle.loadString('assets/data/list-of-lists.yaml');
//       final lists = (loadYaml(yamlString) as YamlMap)['lists'] as YamlList;

//       for (var list in lists) {
//         final bookName = _getText(list['name'], 'ur');
//         final listYaml =
//             await rootBundle.loadString('assets/data/lists/${list['id']}.yaml');
//         final sections =
//             (loadYaml(listYaml) as YamlMap)['sections'] as YamlList;

//         for (var section in sections) {
//           if (section.containsKey('poems')) {
//             for (var poem in (section['poems'] as YamlList)) {
//               final poemId = poem['id'].toString();
//               final poemName = _getText(poem['poemName'], 'ur');
//               _poemsIndex
//                   .add({'id': poemId, 'title': poemName, 'book': bookName});
//             }
//           }
//         }
//       }
//     } catch (e) {}
//     setState(() => _isLoading = false);
//   }

//   String _getText(dynamic list, String lang) {
//     final names = list as YamlList;
//     return names.firstWhere((n) => n['lang'] == lang)['text'] ?? '';
//   }

//   String _cleanText(String text) {
//     return text
//         .toLowerCase()
//         .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')
//         .replaceAll(RegExp(r'\s+'), ' ');
//   }

//   Future<void> _search(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         _isSearching = false;
//         _results.clear();
//       });
//       return;
//     }

//     setState(() => _isSearching = true);
//     final cleanQuery = _cleanText(query);
//     final results = <Map<String, dynamic>>[];

//     if (_filter == 'all' || _filter == 'poems') {
//       for (var poem in _poemsIndex) {
//         if (_cleanText(poem['title']).contains(cleanQuery)) {
//           results.add({
//             'type': 'poem',
//             'id': poem['id'],
//             'title': poem['title'],
//             'subtitle': poem['book']
//           });
//         }
//       }
//     }

//     if ((_filter == 'all' || _filter == 'verses') && results.length < 50) {
//       for (var poem in _poemsIndex) {
//         try {
//           final folder = poem['id'].split('_').first;
//           final yamlString = await rootBundle
//               .loadString('assets/poems/$folder/${poem['id']}.yaml');
//           final shers = (loadYaml(yamlString) as YamlMap)['sher'] as YamlList;

//           for (var sher in shers) {
//             final urText = _getText(sher['sherContent'], 'ur');
//             if (_cleanText(urText).contains(cleanQuery)) {
//               results.add({
//                 'type': 'verse',
//                 'poemId': poem['id'],
//                 'poemTitle': poem['title'],
//                 'text': urText.length > 80
//                     ? '${urText.substring(0, 80)}...'
//                     : urText,
//               });
//               break;
//             }
//           }
//         } catch (e) {}
//         if (results.length > 100) break;
//       }
//     }

//     setState(() {
//       _results.clear();
//       _results.addAll(results);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: const Text('تلاش'),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.info_outline),
//               onPressed: () => _showInfoDialog(context),
//             ),
//           ],
//         ),
//         body: _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: Color(0xFFC3601F)))
//             : Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     child: TextField(
//                       controller: _controller,
//                       onChanged: _search,
//                       autofocus: true,
//                       textDirection: TextDirection.rtl,
//                       decoration: InputDecoration(
//                         hintText: 'شعر یا غزل تلاش کریں...',
//                         hintStyle: GoogleFonts.notoNastaliqUrdu(),
//                         prefixIcon:
//                             const Icon(Icons.search, color: Color(0xFFC3601F)),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none),
//                         filled: true,
//                         fillColor: Colors.white.withValues(alpha:0.9),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       children: [
//                         _buildFilterChip('سب', 'all'),
//                         const SizedBox(width: 8),
//                         _buildFilterChip('غزلیں', 'poems'),
//                         const SizedBox(width: 8),
//                         _buildFilterChip('اشعار', 'verses'),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Expanded(
//                     child: _isSearching
//                         ? _results.isEmpty
//                             ? Center(
//                                 child: Text('کوئی نتیجہ نہیں',
//                                     style: GoogleFonts.notoNastaliqUrdu(
//                                         color: Color(0xFF80461B)
//                                             .withValues(alpha:0.7))))
//                             : ListView.builder(
//                                 padding: const EdgeInsets.all(16),
//                                 itemCount: _results.length,
//                                 itemBuilder: (context, index) => Container(
//                                   margin: const EdgeInsets.only(bottom: 8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withValues(alpha:0.9),
//                                     borderRadius: BorderRadius.circular(16),
//                                     border: Border.all(
//                                         color: const Color(0xFFD1B46D)
//                                             .withValues(alpha:0.3)),
//                                   ),
//                                   child: ListTile(
//                                     title: Text(
//                                         _results[index]['type'] == 'poem'
//                                             ? _results[index]['title']
//                                             : _results[index]['text'],
//                                         style: GoogleFonts.notoNastaliqUrdu(
//                                             fontSize: 14)),
//                                     subtitle: Text(
//                                         _results[index]['type'] == 'poem'
//                                             ? _results[index]['subtitle']
//                                             : _results[index]['poemTitle'],
//                                         style: GoogleFonts.notoNastaliqUrdu(
//                                             fontSize: 12,
//                                             color: const Color(0xFF80461B)
//                                                 .withValues(alpha:0.7))),
//                                     trailing: const Icon(Icons.chevron_right,
//                                         color: Color(0xFFC3601F)),
//                                     onTap: () => Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (_) => PoemDetailScreen(
//                                                   poemId: _results[index]
//                                                               ['type'] ==
//                                                           'poem'
//                                                       ? _results[index]['id']
//                                                       : _results[index]
//                                                           ['poemId'],
//                                                 ))),
//                                   ),
//                                 ),
//                               )
//                         : Center(
//                             child: Text('تلاش شروع کریں',
//                                 style: GoogleFonts.notoNastaliqUrdu(
//                                     color: const Color(0xFF80461B)
//                                         .withValues(alpha:0.7)))),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _showInfoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: borderRadius.circular(24)),
//           title: Text('اقبال ڈیمیسٹیفائیڈ',
//               style: GoogleFonts.notoNastaliqUrdu(
//                   color: const Color(0xFFC3601F), fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('علامہ اقبال کی شاعری کا مجموعہ',
//                   style: GoogleFonts.notoNastaliqUrdu(fontSize: 14)),
//               const SizedBox(height: 12),
//               const Divider(),
//               _buildInfoRow('ورژن', '1.0.0'),
//               _buildInfoRow('غزلیں', '500+'),
//               _buildInfoRow('کتابیں', '11'),
//               const SizedBox(height: 12),
//               const Divider(),
//               Text('رازداری کی پالیسی',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       fontWeight: FontWeight.bold, fontSize: 13)),
//               const SizedBox(height: 4),
//               Text(
//                   'آپ کا ڈیٹا مقامی طور پر محفوظ ہے۔ کوئی ذاتی معلومات جمع نہیں کی جاتی۔',
//                   style: GoogleFonts.poppins(
//                       fontSize: 11, color: Colors.grey[600])),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('بند کریں',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       color: const Color(0xFFC3601F))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: GoogleFonts.notoNastaliqUrdu(fontSize: 13)),
//           Text(value,
//               style: GoogleFonts.poppins(
//                   fontSize: 13, color: const Color(0xFF80461B))),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label, String value) {
//     return Expanded(
//       child: FilterChip(
//         label:
//             Center(child: Text(label, style: GoogleFonts.notoNastaliqUrdu())),
//         selected: _filter == value,
//         onSelected: (s) {
//           setState(() => _filter = value);
//           _search(_controller.text);
//         },
//         backgroundColor: Colors.transparent,
//         selectedColor: const Color(0xFFC3601F),
//         labelStyle: TextStyle(
//             color: _filter == value ? Colors.white : const Color(0xFF80461B)),
//       ),
//     );
//   }
// }

// class FavoritesScreen extends StatelessWidget {
//   const FavoritesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final favorites = Hive.box('favorites').values.toList();

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             title: const Text('پسندیدہ'),
//             bottom: TabBar(
//               tabs: [Tab(text: 'غزلیں'), Tab(text: 'اشعار')],
//               indicatorColor: Color(0xFFC3601F),
//               labelColor: Color(0xFFC3601F),
//               labelStyle: GoogleFonts.notoNastaliqUrdu(),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.info_outline),
//                 onPressed: () => _showInfoDialog(context),
//               ),
//             ],
//           ),
//           body: TabBarView(
//             children: [
//               _buildList(favorites.where((f) => f?['type'] == 'poem').toList(),
//                   context, true),
//               _buildList(favorites.where((f) => f?['type'] == 'verse').toList(),
//                   context, false),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showInfoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: borderRadius.circular(24)),
//           title: Text('اقبال ڈیمیسٹیفائیڈ',
//               style: GoogleFonts.notoNastaliqUrdu(
//                   color: const Color(0xFFC3601F), fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('علامہ اقبال کی شاعری کا مجموعہ',
//                   style: GoogleFonts.notoNastaliqUrdu(fontSize: 14)),
//               const SizedBox(height: 12),
//               const Divider(),
//               _buildInfoRow('ورژن', '1.0.0'),
//               _buildInfoRow('غزلیں', '500+'),
//               _buildInfoRow('کتابیں', '11'),
//               const SizedBox(height: 12),
//               const Divider(),
//               Text('رازداری کی پالیسی',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       fontWeight: FontWeight.bold, fontSize: 13)),
//               const SizedBox(height: 4),
//               Text(
//                   'آپ کا ڈیٹا مقامی طور پر محفوظ ہے۔ کوئی ذاتی معلومات جمع نہیں کی جاتی۔',
//                   style: GoogleFonts.poppins(
//                       fontSize: 11, color: Colors.grey[600])),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('بند کریں',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       color: const Color(0xFFC3601F))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: GoogleFonts.notoNastaliqUrdu(fontSize: 13)),
//           Text(value,
//               style: GoogleFonts.poppins(
//                   fontSize: 13, color: const Color(0xFF80461B))),
//         ],
//       ),
//     );
//   }

//   Widget _buildList(List items, BuildContext context, bool isPoem) {
//     if (items.isEmpty) {
//       return Center(
//           child: Text('کوئی پسندیدہ نہیں',
//               style: GoogleFonts.notoNastaliqUrdu(
//                   color: Color(0xFF80461B).withValues(alpha:0.7))));
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: items.length,
//       itemBuilder: (context, index) => Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(alpha:0.9),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: const Color(0xFFD1B46D).withValues(alpha:0.3)),
//         ),
//         child: ListTile(
//           title: Text(
//             isPoem
//                 ? (items[index]['title']?.toString() ?? 'Untitled')
//                 : (items[index]['text']?.toString() ?? 'No text available'),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: GoogleFonts.notoNastaliqUrdu(fontSize: 14),
//           ),
//           subtitle: !isPoem
//               ? Text(items[index]['poemTitle']?.toString() ?? 'Unknown',
//                   style: GoogleFonts.notoNastaliqUrdu(
//                       fontSize: 12,
//                       color: const Color(0xFF80461B).withValues(alpha:0.7)))
//               : null,
//           trailing: const Icon(Icons.chevron_right, color: Color(0xFFC3601F)),
//           onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => PoemDetailScreen(
//                         poemId: isPoem
//                             ? items[index]['id']
//                             : items[index]['poemId'],
//                       ))),
//         ),
//       ),
//     );
//   }
// }
