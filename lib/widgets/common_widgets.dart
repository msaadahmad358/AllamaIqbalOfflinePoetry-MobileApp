import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';

class CommonWidgets {
  static void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Image.asset(
          'assets/images/icon.png',
          height: 100,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            buildInfoRow('Version', '1.0.0'),
            buildInfoRow('Ghazals', '1000+'),
            buildInfoRow('Books', '11'),
            const SizedBox(height: 12),
            const Divider(),
            Text('Privacy Policy',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppTheme.primaryColor)),
            const SizedBox(height: 4),
            Text('Your data is secure. No Privacy data collected by us.',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppTheme.primaryColor)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: GoogleFonts.poppins(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  static Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppTheme.primaryColor)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppTheme.primaryColor)),
        ],
      ),
    );
  }
}
