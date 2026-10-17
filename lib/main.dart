import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/search_favorites.dart';

import 'core/theme.dart';
import 'core/helpers.dart';
import 'screens/home_screen.dart';

// ==================== ENTRY ====================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await Hive.openBox('recent');

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const IqbalPoetryApp(),
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
      title: 'Allama Iqbal Offline Poetry',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const SplashScreen(),
      builder: DevicePreview.appBuilder,
    );
  }
}

// ==================== SYSTEM UI CONSTANTS ====================
const _lightIcons = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);
const _darkIcons = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

SystemUiOverlayStyle iconsFor(BookTone t) =>
    t.hasLightText ? _lightIcons : _darkIcons;

// ==================== SPLASH ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const _heights = [92.0, 132.0, 74.0, 112.0, 150.0, 98.0, 122.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _darkIcons,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final v = _controller.value;
              final nameOpacity = Interval(0.55, 1.0).transform(v);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (int i = 0; i < _heights.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                              width: 18,
                              height: _heights[i] *
                                  Curves.easeOutCubic.transform(
                                    Interval(i * 0.07, i * 0.07 + 0.45)
                                        .transform(v),
                                  ),
                              decoration: BoxDecoration(
                                color: AppTheme.tones[i].bg,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Opacity(
                    opacity: nameOpacity,
                    child: Text('علامہ محمد اقبال',
                        textDirection: TextDirection.rtl,
                        style: AppText.urdu(44, height: 1.7)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==================== MAIN SHELL ====================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _darkIcons,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: _NavBar(
          selected: _selectedIndex,
          onTap: (i) {
            if (i == _selectedIndex) return;
            HapticFeedback.selectionClick();
            setState(() => _selectedIndex = i);
          },
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _NavBar({required this.selected, required this.onTap});

  static const _items = [
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'Library'),
    (Icons.search_rounded, Icons.search_rounded, 'Search'),
    (Icons.bookmark_border_rounded, Icons.bookmark_rounded, 'Saved'),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 6, 28, 14),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.ink.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                for (int i = 0; i < _items.length; i++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(i),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          decoration: BoxDecoration(
                            color: i == selected
                                ? AppTheme.accent.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                i == selected ? _items[i].$2 : _items[i].$1,
                                size: 22,
                                color: i == selected
                                    ? AppTheme.accent
                                    : AppTheme.textMuted,
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 240),
                                curve: Curves.easeOutCubic,
                                child: i == selected
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(_items[i].$3,
                                            style: AppText.sans(13.5,
                                                weight: FontWeight.w600,
                                                color: AppTheme.accent)),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
