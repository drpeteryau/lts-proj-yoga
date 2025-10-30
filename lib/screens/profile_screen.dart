import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _primaryColor = Color(0xFF40E0D0);
  static const Color _textColor = Colors.black87;

  // Dropdown Options Data
  final List<String> _ageGroupOptions = ['18-24 years', '25-34 years', '35-44 years', '45-54 years', '55-64 years', '65-74 years', '75+ years'];
  final List<String> _experienceOptions = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> _sessionLengthOptions = ['5 minutes', '10 minutes', '15 minutes', '20 minutes', '30 minutes'];
  final List<String> _languageOptions = ['English', 'Mandarin', 'Tamil', 'Malay'];

  // Variables for dropdown
  String _ageGroup = '65-74 years';
  String _experienceLevel = 'Beginner';
  String _preferredSessionLength = '15 minutes';

  bool _pushNotificationsEnabled = true;
  bool _dailyPracticeReminderEnabled = true;
  String _reminderTime = '9:00 AM';

  bool _soundEffectsEnabled = true;
  double _volumeLevel = 0.8;

  String _preferredLanguage = 'English';


  // Dropdown selections
  void _showSelectionSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == currentValue;
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? _primaryColor : _textColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: _primaryColor) : null,
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Toggle Setting
  Widget _buildToggleSetting({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, color: _textColor),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _primaryColor, // Turquoise color when active
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  // Dropdown Setting
  Widget _buildDropdownSetting({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: _textColor),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Settings Card Builder
  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24.0), // Consistent spacing between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // Profile Card
  Widget _buildProfileCard() {
    return _buildSettingsCard(
      icon: Icons.person_outline,
      title: 'Profile',
      iconColor: _primaryColor,
      children: [
        _buildDropdownSetting(
          label: 'Age Group',
          value: _ageGroup,
          onTap: () => _showSelectionSheet(
            title: 'Select Age Group',
            options: _ageGroupOptions,
            currentValue: _ageGroup,
            onSelected: (newValue) => setState(() => _ageGroup = newValue),
          ),
        ),
        const Divider(height: 1, color: Colors.black12),
        _buildDropdownSetting(
          label: 'Experience Level',
          value: _experienceLevel,
          onTap: () => _showSelectionSheet(
            title: 'Select Experience Level',
            options: _experienceOptions,
            currentValue: _experienceLevel,
            onSelected: (newValue) => setState(() => _experienceLevel = newValue),
          ),
        ),
        const Divider(height: 1, color: Colors.black12),
        _buildDropdownSetting(
          label: 'Preferred Session Length',
          value: _preferredSessionLength,
          onTap: () => _showSelectionSheet(
            title: 'Select Session Length',
            options: _sessionLengthOptions,
            currentValue: _preferredSessionLength,
            onSelected: (newValue) => setState(() => _preferredSessionLength = newValue),
          ),
        ),
      ],
    );
  }

  // Notifications Card
  Widget _buildNotificationsCard() {
    return _buildSettingsCard(
      icon: Icons.notifications_none,
      title: 'Notifications',
      iconColor: _primaryColor,
      children: [
        _buildToggleSetting(
          label: 'Push Notifications',
          subtitle: 'Get reminders and updates',
          value: _pushNotificationsEnabled,
          onChanged: (newValue) => setState(() => _pushNotificationsEnabled = newValue),
        ),
        const Divider(height: 1, color: Colors.black12),
        _buildToggleSetting(
          label: 'Daily Practice Reminder',
          subtitle: 'Gentle daily reminders',
          value: _dailyPracticeReminderEnabled,
          onChanged: (newValue) => setState(() => _dailyPracticeReminderEnabled = newValue),
        ),
        const Divider(height: 1, color: Colors.black12),
        _buildDropdownSetting(
          label: 'Reminder Time',
          value: _reminderTime,
          onTap: () async {
            final TimeOfDay? newTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (newTime != null) {
              setState(() {
                _reminderTime = newTime.format(context);
              });
            }
          },
        ),
      ],
    );
  }

  // Audio Settings Card
  Widget _buildAudioSettingsCard() {
    return _buildSettingsCard(
      icon: Icons.volume_up_outlined,
      title: 'Audio Settings',
      iconColor: _primaryColor,
      children: [
        // Sound Effects Toggle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sound Effects',
                    style: TextStyle(fontSize: 16, color: _textColor),
                  ),
                  Text(
                    'Play sounds during sessions',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              Switch(
                value: _soundEffectsEnabled,
                onChanged: (newValue) => setState(() => _soundEffectsEnabled = newValue),
                activeColor: Colors.white,
                activeTrackColor: _primaryColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ],
          ),
        ),
        
        const Divider(height: 1, color: Colors.black12),
        const SizedBox(height: 8),

        // Volume Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                'Volume Level: ${(_volumeLevel * 100).round()}%',
                style: const TextStyle(fontSize: 16, color: _textColor),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 10.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _volumeLevel,
                min: 0.0,
                max: 1.0,
                divisions: 100,
                activeColor: _primaryColor,
                inactiveColor: _primaryColor.withOpacity(0.2),
                onChanged: (double newValue) => setState(() => _volumeLevel = newValue),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Language Card
  Widget _buildLanguageCard() {
    return _buildSettingsCard(
      icon: Icons.language,
      title: 'Language & Region',
      iconColor: _primaryColor,
      children: [
        _buildDropdownSetting(
          label: 'Preferred Language',
          value: _preferredLanguage,
          onTap: () => _showSelectionSheet(
            title: 'Select Preferred Language',
            options: _languageOptions,
            currentValue: _preferredLanguage,
            onSelected: (newValue) => setState(() => _preferredLanguage = newValue),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Profile Header ---
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: _primaryColor.withOpacity(0.2),
                      child: const Icon(Icons.person, size: 50, color: _primaryColor),
                    ),
                    const SizedBox(height: 12),
                    const Text('Jane Doe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor)),
                    const SizedBox(height: 4),
                    Text('Edit Profile', style: TextStyle(fontSize: 14, decoration: TextDecoration.underline, color: Colors.grey[600])),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Cards
              _buildProfileCard(),
              _buildNotificationsCard(),
              _buildAudioSettingsCard(),
              _buildLanguageCard(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
