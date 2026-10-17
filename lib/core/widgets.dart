import 'package:flutter/material.dart';
import 'theme.dart';
import 'helpers.dart';

class AutoText extends StatelessWidget {
  final String text;
  final double urduSize;
  final double latinSize;
  final Color color;
  final int? maxLines;
  final TextAlign? align;
  final double urduHeight;

  const AutoText(
    this.text, {
    super.key,
    this.urduSize = 20,
    this.latinSize = 15,
    this.color = AppTheme.textPrimary,
    this.maxLines,
    this.align,
    this.urduHeight = 1.9,
  });

  @override
  Widget build(BuildContext context) {
    final rtl = TextHelpers.isUrdu(text);
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      textAlign: align,
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      style: rtl
          ? AppText.urdu(urduSize, color: color, height: urduHeight)
          : AppText.sans(latinSize,
              color: color, weight: FontWeight.w500, height: 1.5),
    );
  }
}

class BrandMark extends StatelessWidget {
  final double size;
  const BrandMark({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Image.asset('assets/images/icon.png', fit: BoxFit.cover),
      ),
    );
  }
}

class BookTile extends StatefulWidget {
  final String urdu;
  final String english;
  final BookTone tone;
  final VoidCallback onTap;
  const BookTile({
    super.key,
    required this.urdu,
    required this.english,
    required this.tone,
    required this.onTap,
  });

  @override
  State<BookTile> createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.tone;
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: t.bg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: t.bg.withOpacity(0.32),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Container(width: 9, color: Colors.black.withOpacity(0.16)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 22, 14, 18),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.urdu,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.urdu(27, color: t.fg, height: 1.95),
                          ),
                        ),
                      ),
                      if (widget.english.isNotEmpty)
                        Text(
                          widget.english,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(11.5,
                              color: t.fg.withOpacity(0.72), height: 1.35),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final List<Widget> actions;
  final bool showBack;
  final Color color;
  const TopBar({
    super.key,
    this.actions = const [],
    this.showBack = true,
    this.color = AppTheme.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            if (showBack)
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: color),
                onPressed: () => Navigator.maybePop(context),
              )
            else
              const SizedBox(width: 24),
            const Spacer(),
            ...actions,
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  const PageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 12, 20),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: AppText.serif(34, weight: FontWeight.w500)),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline_rounded,
                  size: 21, color: AppTheme.textSecondary),
              onPressed: () => CommonWidgets.showInfoDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

class PillTabs extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  const PillTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < labels.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: i == selected ? AppTheme.ink : AppTheme.surface,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  labels[i],
                  style: AppText.sans(
                    13.5,
                    weight: FontWeight.w500,
                    color:
                        i == selected ? AppTheme.onInk : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  const EmptyState({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: AppText.sans(16,
                    weight: FontWeight.w500, color: AppTheme.textPrimary)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!,
                  textAlign: TextAlign.center,
                  style:
                      AppText.sans(13, color: AppTheme.textMuted, height: 1.6)),
            ],
          ],
        ),
      ),
    );
  }
}

class CommonWidgets {
  static void showInfoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BrandMark(size: 64),
              const SizedBox(height: 14),
              Text('علامہ محمد اقبال',
                  textDirection: TextDirection.rtl,
                  style: AppText.urdu(28, height: 1.7)),
              const SizedBox(height: 2),
              Text('Version 1.0.0',
                  style: AppText.sans(12.5, color: AppTheme.textMuted)),
              const SizedBox(height: 22),
              Text(
                'Everything stays on this device. Nothing is collected.',
                textAlign: TextAlign.center,
                style: AppText.sans(13.5,
                    color: AppTheme.textSecondary, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
