import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';

class SherCardWidget extends StatelessWidget {
  final int index;
  final String urText;
  final String enText;
  final bool isFavorite;
  final bool showTranslation;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleTranslation;
  final VoidCallback onCopy;

  const SherCardWidget({
    Key? key,
    required this.index,
    required this.urText,
    required this.enText,
    required this.isFavorite,
    required this.showTranslation,
    required this.onToggleFavorite,
    required this.onToggleTranslation,
    required this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleTranslation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: isFavorite ? AppTheme.secondaryColor : Colors.transparent,
              width: isFavorite ? 2 : 2),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: AppTheme.darkColor),
                  onPressed: onToggleFavorite,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text('${index + 1}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor.withValues(alpha: 0.6))),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onLongPress: onCopy,
              child: Text(
                urText,
                style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 18, height: 2, color: AppTheme.darkColor),
                textAlign: TextAlign.center,
              ),
            ),
            if (showTranslation) ...[
              const SizedBox(height: 20),
              Divider(color: AppTheme.accentColor.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              Text(
                enText,
                style: GoogleFonts.poppins(
                    fontSize: 14, height: 1.4, color: AppTheme.secondaryColor),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            Text(
              showTranslation ? '▲ ترجمہ چھپائیں' : '▼ ترجمہ دیکھیں',
              style: GoogleFonts.notoNastaliqUrdu(
                  fontSize: 11,
                  color: AppTheme.primaryColor.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
