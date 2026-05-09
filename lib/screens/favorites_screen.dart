import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/theme_config.dart';
 import 'poem_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Hive.box('favorites').values.toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 100,
            title: Image.asset(
              'assets/images/icon.png',
              height: 100,
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'غزلیں'),
                Tab(text: 'اشعار'),
              ],
              unselectedLabelColor: AppTheme.secondaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: AppTheme.primaryColor,
              dividerColor: Colors.transparent,
              labelColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              _buildList(favorites.where((f) => f?['type'] == 'poem').toList(),
                  context, true),
              _buildList(favorites.where((f) => f?['type'] == 'verse').toList(),
                  context, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List items, BuildContext context, bool isPoem) {
    if (items.isEmpty) {
      return Center(
          child: Text('کوئی پسندیدہ نہیں',
              style: GoogleFonts.notoNastaliqUrdu(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.7))));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.secondaryColor, width: 2),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            isPoem
                ? (items[index]['title']?.toString() ?? 'Untitled')
                : (items[index]['text']?.toString() ?? 'No text available'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoNastaliqUrdu(fontSize: 16),
          ),
          subtitle: !isPoem
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Text(
                      items[index]['poemTitle']?.toString() ?? 'Unknown',
                      style: GoogleFonts.notoNastaliqUrdu(
                          fontSize: 14, color: AppTheme.darkColor)),
                )
              : null,
          trailing: const Icon(Icons.chevron_right, color: AppTheme.darkColor),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PoemDetailScreen(
                        poemId: isPoem
                            ? items[index]['id']
                            : items[index]['poemId'],
                      ))),
        ),
      ),
    );
  }
}
