import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_tab_screen.dart';
import 'progress_screen.dart';
import 'meditation_screen.dart';
import 'profile_screen.dart';
import 'level_selection_screen.dart';
import '../widgets/mini_playback_bar.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeTabScreen(),
    LevelSelectionScreen(),
    ProgressScreen(),
    MeditationScreen(),
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
          _buildTopNav(),
          Expanded(child: _screens[_selectedIndex]),
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
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.self_improvement,
                      color: Color(0xFF40E0D0),
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'HEAL',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color:
                            const Color(0xFF1F3D3A),
                      ),
                    ),
                    Text(
                      'YOGA',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color:
                            const Color(0xFF40E0D0),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildTopNavItem(0, 'HOME'),
                    _buildTopNavItem(1, 'SESSIONS'),
                    _buildTopNavItem(2, 'PROGRESS'),
                    _buildTopNavItem(3, 'MEDITATION'),
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
        padding:
            const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected
                ? FontWeight.w600
                : FontWeight.w400,
            color: isSelected
                ? const Color(0xFF000000)
                : const Color(0xFF6B7280),
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
          Expanded(child: _screens[_selectedIndex]),
          const MiniPlaybackBar(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDFA),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                    child: _buildNavItem(
                        0,
                        Icons.home_filled,
                        AppLocalizations.of(context)!
                            .navHome)),
                Expanded(
                    child: _buildNavItem(
                        1,
                        Icons.spa_rounded,
                        AppLocalizations.of(context)!
                            .navSessions)),
                Expanded(
                    child: _buildNavItem(
                        2,
                        Icons.timeline_rounded,
                        AppLocalizations.of(context)!
                            .navProgress)),
                Expanded(
                    child: _buildNavItem(
                        3,
                        Icons.self_improvement,
                        AppLocalizations.of(context)!
                            .navMeditation)),
                Expanded(
                    child: _buildNavItem(
                        4,
                        Icons.person_rounded,
                        AppLocalizations.of(context)!
                            .navProfile)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () async {
        await GlobalAudioService.playClickSound();
        setState(() => _selectedIndex = index);
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white
                        .withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 1,
                    offset:
                        const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF000000)
                  : Colors.grey[500],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              textAlign:
                  TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: isSelected
                    ? const Color(
                        0xFF000000)
                    : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}