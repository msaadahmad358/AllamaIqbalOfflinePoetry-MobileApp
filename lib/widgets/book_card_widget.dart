import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';

class BookCardWidget extends StatelessWidget {
  final String nameUr;
  final String nameEn;
  final int index;
  final VoidCallback onTap;

  const BookCardWidget({
    Key? key,
    required this.nameUr,
    required this.nameEn,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppTheme.accentColor.withValues(alpha: 0.3), width: 0.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.darkColor,
            // gradient: LinearGradient(
            //     colors: [AppTheme.primaryColor, AppTheme.accentColor]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Text('${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
        ),
        title: Text(nameUr,
            style: GoogleFonts.notoNastaliqUrdu(
                fontWeight: FontWeight.w500, fontSize: 20)),
        // subtitle: Text(nameEn,
        //     style: GoogleFonts.notoNastaliqUrdu(
        //         fontSize: 13, color: AppTheme.secondaryColor.withValues(alpha:0.7))),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.darkColor),
        onTap: onTap,
      ),
    );
  }
}
