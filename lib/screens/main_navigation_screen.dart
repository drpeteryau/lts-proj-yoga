import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_tab_screen.dart';
import 'progress_screen.dart';
import 'sounds_screen.dart';
import 'profile_screen.dart';
import 'level_selection_screen.dart';
import '../widgets/mini_playback_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeTabScreen(),
    LevelSelectionScreen(),
    ProgressScreen(),
    SoundsScreen(),
    ProfileScreen(),
  ];

  bool get isWeb => MediaQuery.of(context).size.width > 600;

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return _buildWeb();
    }
    return _buildMobile();
  }

  // ===================== WEB LAYOUT =====================
  Widget _buildWeb() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top navigation bar
          _buildTopNav(),
          // Main content
          Expanded(
            child: _screens[_selectedIndex],
          ),
          // Mini playback bar
          const MiniPlaybackBar(),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo / Brand — left side
                Row(
                  children: [
                    Icon(
                      Icons.self_improvement,
                      color: const Color(0xFF40E0D0),
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'HEAL',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F3D3A),
                      ),
                    ),
                    Text(
                      'YOGA',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF40E0D0),
                      ),
                    ),
                  ],
                ),
                // Nav links — right side
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildTopNavItem(0, 'HOME'),
                    _buildTopNavItem(1, 'SESSIONS'),
                    _buildTopNavItem(2, 'PROGRESS'),
                    _buildTopNavItem(3, 'SOUNDS'),
                    _buildTopNavItem(4, 'PROFILE'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavItem(int index, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? const Color(0xFF40E0D0) : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  // ===================== MOBILE LAYOUT =====================
  Widget _buildMobile() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Main content
          Expanded(
            child: _screens[_selectedIndex],
          ),
          // Mini playback bar (appears above bottom nav when music is playing)
          const MiniPlaybackBar(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.self_improvement, 'Sessions'),
                _buildNavItem(2, Icons.track_changes, 'Progress'),
                _buildNavItem(3, Icons.music_note, 'Sounds'),
                _buildNavItem(4, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Glow effect when selected
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF40E0D0).withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF40E0D0) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF40E0D0) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}