import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

    @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

    // ==============================
  //  Supabase Profile Loader
  // ==============================

  // These keep track of the user data pulled from Supabase
Map<String, dynamic>? _profileData;
bool _isLoadingProfile = true;

@override
void initState() {
  super.initState();
  _loadProfileData();
}

Future<void> _loadProfileData() async {
  debugPrint('🔄 Loading profile data...');

  // Wait a short moment to let Supabase restore session
  await Future.delayed(const Duration(milliseconds: 300));
  final user = Supabase.instance.client.auth.currentUser;

 if (user == null) {
    debugPrint('⚠️ No Supabase user found — redirecting to login');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
    return;
  }

  try {
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

        debugPrint('✅ Profile data loaded: $response');


    setState(() {
      _profileData = response;
      _isLoadingProfile = false;
      _nameController.text = response['full_name'] ?? '';
      _ageController.text = response['age']?.toString() ?? '';
      _email = response['email'] ?? ''; 
      _ageGroup = response['age_group'] ?? _ageGroup;
      _experienceLevel = response['experience_level'] ?? _experienceLevel;
      _preferredSessionLength = response['preferred_session_length'] ?? _preferredSessionLength;
      _preferredLanguage = response['preferred_language'] ?? _preferredLanguage;
      _soundEffectsEnabled = response['sound_effects_enabled'] ?? _soundEffectsEnabled;
      _volumeLevel = (response['volume_level'] as num?)?.toDouble() ?? _volumeLevel;
      _reminderTime = response['reminder_time'] ?? _reminderTime;
      _dailyPracticeReminderEnabled = response['daily_practice_reminder'] ?? _dailyPracticeReminderEnabled;
      _pushNotificationsEnabled = response['push_notifications_enabled'] ?? _pushNotificationsEnabled;
    });
  } catch (e) {
    debugPrint('Error loading profile: $e');
     setState(() {
      _isLoadingProfile = false;
    });
  }
}

Future<void> _updateProfileField(String field, dynamic value) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return;

  try {
    await Supabase.instance.client
        .from('profiles')
        .update({field: value})
        .eq('id', user.id);
  } catch (e) {
    debugPrint('Error updating $field: $e');
  }
}


  static const Color _primaryColor = Color(0xFF40E0D0);
  static const Color _textColor = Colors.black87;

  String _email = '';


    // --- 🔒 Secure Logout Function ---
  Future<void> _signOut(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }


  // Localization Data
  final Map<String, Map<String, String>> _localizedStrings = {
    'English': {
      'title_edit_profile': 'Edit Profile',
      'card_profile': 'Profile',
      'setting_age_group': 'Age Group',
      'setting_experience_level': 'Experience Level',
      'setting_session_length': 'Preferred Session Length',
      'sheet_select_age': 'Select Age Group',
      'sheet_select_experience': 'Select Experience Level',
      'sheet_select_session': 'Select Session Length',
      'card_notifications': 'Notifications',
      'setting_push_notifications': 'Push Notifications',
      'subtitle_push_notifications': 'Get reminders and updates',
      'setting_daily_reminder': 'Daily Practice Reminder',
      'subtitle_daily_reminder': 'Gentle daily reminders',
      'setting_reminder_time': 'Reminder Time',
      'card_audio_settings': 'Audio Settings',
      'setting_sound_effects': 'Sound Effects',
      'subtitle_sound_effects': 'Play sounds during sessions',
      'setting_volume_level': 'Volume Level',
      'card_language_region': 'Language & Region',
      'setting_preferred_language': 'Preferred Language',
      'sheet_select_language': 'Select Preferred Language',
      'logout': 'Logout',
    },
    'Mandarin': {
      'title_edit_profile': '编辑个人资料',
      'card_profile': '个人资料',
      'setting_age_group': '年龄组',
      'setting_experience_level': '经验水平',
      'setting_session_length': '首选会话时长',
      'sheet_select_age': '选择年龄组',
      'sheet_select_experience': '选择经验水平',
      'sheet_select_session': '选择会话时长',
      'card_notifications': '通知',
      'setting_push_notifications': '推送通知',
      'subtitle_push_notifications': '获取提醒和更新',
      'setting_daily_reminder': '每日练习提醒',
      'subtitle_daily_reminder': '温和的日常提醒',
      'setting_reminder_time': '提醒时间',
      'card_audio_settings': '音频设置',
      'setting_sound_effects': '声音效果',
      'subtitle_sound_effects': '在会话期间播放声音',
      'setting_volume_level': '音量级别',
      'card_language_region': '语言与区域',
      'setting_preferred_language': '首选语言',
      'sheet_select_language': '选择首选语言',
      'logout': '登出',
    },
  };

//  Toggles edit/view mode for the name & age fields
  bool _isEditing = false;


final TextEditingController _nameController = TextEditingController();
final TextEditingController _ageController = TextEditingController();

//  Helper function to auto-categorize age group
String _getAgeGroup(int age) {
  if (age < 18) return 'Under 18';
  if (age <= 24) return '18–24 years';
  if (age <= 34) return '25–34 years';
  if (age <= 44) return '35–44 years';
  if (age <= 54) return '45–54 years';
  if (age <= 64) return '55–64 years';
  if (age <= 74) return '65–74 years';
  return '75+ years';
}



  // Helper getter to fetch localized string
  String _localizedText(String key) {
    return _localizedStrings[_preferredLanguage]?[key] ?? key;
  }

  // Dropdown Options Data
  final List<String> _ageGroupOptions = [
    'Under 18',
    '18-24 years',
    '25-34 years',
    '35-44 years',
    '45-54 years',
    '55-64 years',
    '65-74 years',
    '75+ years',
  ];
  final List<String> _experienceOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  final List<String> _sessionLengthOptions = [
    '5 minutes',
    '10 minutes',
    '15 minutes',
    '20 minutes',
    '30 minutes',
  ];
  final List<String> _languageOptions = ['English', 'Mandarin'];

  // State Variables
  String _preferredLanguage = 'English'; // Key for localization map

  // Profile
  String _ageGroup = '65-74 years';
  String _experienceLevel = 'Beginner';
  String _preferredSessionLength = '15 minutes';

  // Notifications
  bool _pushNotificationsEnabled = true;
  bool _dailyPracticeReminderEnabled = true;
  String _reminderTime = '9:00 AM';

  // Audio Settings
  bool _soundEffectsEnabled = true;
  double _volumeLevel = 0.8;

  // --- Helper Widgets and Functions ---

  // Custom Modal Bottom Sheet to handle dropdown selections
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
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: _primaryColor)
                          : null,
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

  // 1. Toggle Setting
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
                label, // Localized
                style: const TextStyle(fontSize: 16, color: _textColor),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle, // Localized
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _primaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  // 2. Dropdown Setting
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
              label, // Localized
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

  // 3. Settings Card Builder
  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24.0),
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
                  title, // Localized
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

  // 4. Profile Card (Interactive Dropdowns)
  Widget _buildProfileCard() {
    return _buildSettingsCard(
      icon: Icons.person_outline,
      title: _localizedText('card_profile'),
      iconColor: _primaryColor,
      children: [
        // Age Group Dropdown
        _buildDropdownSetting(
  label: _localizedText('setting_age_group'),
  value: _ageGroup,
  onTap: () => _showSelectionSheet(
    title: _localizedText('sheet_select_age'),
    options: _ageGroupOptions,
    currentValue: _ageGroup,
    onSelected: (newValue) {
      setState(() => _ageGroup = newValue);
      _updateProfileField('age_group', newValue);
    },
  ),
),
        const Divider(height: 1, color: Colors.black12),
        // Experience Level Dropdown
        _buildDropdownSetting(
  label: _localizedText('setting_experience_level'),
  value: _experienceLevel,
  onTap: () => _showSelectionSheet(
    title: _localizedText('sheet_select_experience'),
    options: _experienceOptions,
    currentValue: _experienceLevel,
    onSelected: (newValue) {
      setState(() => _experienceLevel = newValue);
      _updateProfileField('experience_level', newValue); // 👈 Save to Supabase
    },
  ),
),
        const Divider(height: 1, color: Colors.black12),
        // Preferred Session Length Dropdown
    _buildDropdownSetting(
  label: _localizedText('setting_session_length'),
  value: _preferredSessionLength,
  onTap: () => _showSelectionSheet(
    title: _localizedText('sheet_select_session'),
    options: _sessionLengthOptions,
    currentValue: _preferredSessionLength,
    onSelected: (newValue) {
      setState(() => _preferredSessionLength = newValue);
      _updateProfileField('preferred_session_length', newValue);
    },
  ),
),

      ],
    );
  }

  // 5. Notifications Card
  Widget _buildNotificationsCard() {
    return _buildSettingsCard(
      icon: Icons.notifications_none,
      title: _localizedText('card_notifications'),
      iconColor: _primaryColor,
      children: [
        _buildToggleSetting(
          label: _localizedText('setting_push_notifications'),
          subtitle: _localizedText('subtitle_push_notifications'),
          value: _pushNotificationsEnabled,
         onChanged: (newValue) {
          setState(() => _pushNotificationsEnabled = newValue);
          _updateProfileField('push_notifications_enabled', newValue);
        },
        ),
        const Divider(height: 1, color: Colors.black12),
        _buildToggleSetting(
          label: _localizedText('setting_daily_reminder'),
          subtitle: _localizedText('subtitle_daily_reminder'),
          value: _dailyPracticeReminderEnabled,
          onChanged: (newValue) {
          setState(() => _dailyPracticeReminderEnabled = newValue);
          _updateProfileField('daily_practice_reminder', newValue); // ✅ update Supabase
        },
        ),
        const Divider(height: 1, color: Colors.black12),
       _buildDropdownSetting(
  label: _localizedText('setting_reminder_time'),
  value: _reminderTime,
  onTap: () async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newTime != null) {
      final formattedTime = newTime.format(context);

      setState(() {
        _reminderTime = formattedTime;
      });

      // 🔥 Save to Supabase
      _updateProfileField('reminder_time', formattedTime);
    }
  },
),

      ],
    );
  }

  // 6. Audio Settings Card
  Widget _buildAudioSettingsCard() {
    return _buildSettingsCard(
      icon: Icons.volume_up_outlined,
      title: _localizedText('card_audio_settings'),
      iconColor: _primaryColor,
      children: [
        // Sound Effects Toggle (with subtitle)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizedText('setting_sound_effects'),
                    style: const TextStyle(fontSize: 16, color: _textColor),
                  ),
                  Text(
                    _localizedText('subtitle_sound_effects'),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              Switch(
                value: _soundEffectsEnabled,
                 onChanged: (newValue) {
                setState(() => _soundEffectsEnabled = newValue);
                _updateProfileField('sound_effects_enabled', newValue); // ✅ update Supabase
              },
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

        // Volume Slider (with localized label)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                '${_localizedText('setting_volume_level')}: ${(_volumeLevel * 100).round()}%',
                style: const TextStyle(fontSize: 16, color: _textColor),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 10.0,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8.0,
                ),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _volumeLevel,
                min: 0.0,
                max: 1.0,
                divisions: 100,
                activeColor: _primaryColor,
                inactiveColor: _primaryColor.withOpacity(0.2),
                 onChanged: (double newValue) {
                setState(() => _volumeLevel = newValue);
                _updateProfileField('volume_level', newValue); // ✅ update Supabase
              },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 7. Language & Region Card (Now updates the localization state)
  Widget _buildLanguageCard() {
    return _buildSettingsCard(
      icon: Icons.language,
      title: _localizedText('card_language_region'),
      iconColor: _primaryColor,
      children: [
_buildDropdownSetting(
  label: _localizedText('setting_preferred_language'),
  value: _preferredLanguage,
  onTap: () => _showSelectionSheet(
    title: _localizedText('sheet_select_language'),
    options: _languageOptions,
    currentValue: _preferredLanguage,
    onSelected: (newValue) {
      setState(() => _preferredLanguage = newValue);

      // 🔥 Save to Supabase
      _updateProfileField('preferred_language', newValue);
    },
  ),
),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primaryColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Profile Header ---
         Card(
  margin: const EdgeInsets.symmetric(vertical: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  elevation: 2,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Profile Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_isEditing) {
                  // Save to Supabase when exiting edit mode

                  final newName = _nameController.text.trim();
                  final newAge = int.tryParse(_ageController.text.trim());
                  if (newName.isNotEmpty) {
                    await _updateProfileField('full_name', newName);
                  }
                  if (newAge != null) {
                    final ageGroup = _getAgeGroup(newAge);
                    await _updateProfileField('age', newAge);
                    await _updateProfileField('age_group', ageGroup);
                    setState(() => _ageGroup = ageGroup);
                  }
                      // Show confirmation
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated successfully')),
                        );
                      }
                    }
  
  // Toggle edit mode (this runs for both Edit and Save)
  setState(() => _isEditing = !_isEditing);

              },
              child: Text(
                _isEditing ? 'Save' : 'Edit',
                style: const TextStyle(color: Color(0xFF40E0D0)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Full Name Field
        TextField(
          controller: _nameController,
          enabled: _isEditing,
          decoration: InputDecoration(
          labelText: 'Full Name',
          border: const OutlineInputBorder(),
          fillColor: _isEditing ? Colors.white : Colors.grey.shade200,
          filled: true,
          ),

        ),
            // ------------- EMAIL DISPLAY -------------
    Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4.0),
      child: Row(
        children: [
          const Icon(Icons.email_outlined, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              _email.isNotEmpty ? _email : 'No email linked',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),

        const SizedBox(height: 12),
//Age field
TextField(
  controller: _ageController,
  enabled: _isEditing,
  keyboardType: TextInputType.number,
  decoration:  InputDecoration(
    labelText: 'Age',
    border: OutlineInputBorder(),
  ),
  onSubmitted: (newAgeString) {
    final newAge = int.tryParse(newAgeString);
    if (newAge != null) {
      final ageGroup = _getAgeGroup(newAge);

      // 👇 this updates your UI immediately
      setState(() {
        _ageGroup = ageGroup;
      });

      // 👇 this saves to Supabase
      _updateProfileField('age', newAge);
      _updateProfileField('age_group', ageGroup);
    }
  },
),
if (_ageController.text.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 4.0),
    child: Text(
      'Age Group: $_ageGroup',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
  ),



      ],
    ),
  ),
),


              const SizedBox(height: 24),

              // --- CARDS (Now fully localized) ---
              _buildProfileCard(),
              _buildNotificationsCard(),
              _buildAudioSettingsCard(),
              _buildLanguageCard(),

              const SizedBox(height: 20),

                // --- 🔒 Logout Button ---
              ElevatedButton.icon(
                onPressed: () => _signOut(context),
                icon: const Icon(Icons.logout),
                label: Text(
                  _localizedText('logout'),
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
