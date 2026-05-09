import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../config/theme_config.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkColor,
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: const AssetImage('assets/images/bg.png'),
        //     fit: BoxFit.cover,
        //     colorFilter: ColorFilter.mode(
        //       Colors.white.withValues(alpha:0.3),
        //       BlendMode.srcOver,
        //     ),
        //   ),
        // ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: ClipRRect(
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.darkColor,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);
              HapticFeedback.lightImpact();
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.secondaryColor,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedLabelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            unselectedLabelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 32,
                  ),
                  label: 'Home',
                  activeIcon: Icon(
                    Icons.home,
                    size: 32,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search_outlined,
                    size: 32,
                  ),
                  label: 'Search',
                  activeIcon: Icon(
                    Icons.search,
                    size: 32,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_border,
                    size: 32,
                  ),
                  label: 'Favorites',
                  activeIcon: Icon(
                    Icons.favorite,
                    size: 32,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
