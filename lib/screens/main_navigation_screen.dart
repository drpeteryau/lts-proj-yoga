import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_tab_screen.dart';
import 'progress_screen.dart';
import 'sounds_screen.dart';
import 'profile_screen.dart';
import 'level_selection_screen.dart';
import '../widgets/mini_playback_bar.dart';
import '../services/global_audio_service.dart';

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

  @override
  Widget build(BuildContext context) {
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
      onTap: () async {
        await GlobalAudioService.playClickSound();
        setState(() => _selectedIndex = index);
      },
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