import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/notification_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final supabase = Supabase.instance.client;

  // Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _profileImageUrl;

  // Profile values
  String _experienceLevel = 'Beginner';
  String _sessionLength = '15 minutes';
  String _language = 'English';

  // Notification & sound settings
  bool _pushNotifications = true;
  bool _dailyPracticeReminder = true;
  String _reminderTime = '9:00 AM';
  bool _soundEffectsEnabled = true;
  double _volumeLevel = 0.8;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ===================== LOAD PROFILE =====================
  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (profile != null) {
      _nameController.text = profile['full_name'] ?? '';
      _ageController.text = profile['age']?.toString() ?? '';
      _experienceLevel = profile['experience_level'] ?? 'Beginner';
      _sessionLength = profile['preferred_session_length'] ?? '15 minutes';
      _language = profile['preferred_language'] ?? 'English';

      _pushNotifications = profile['push_notifications_enabled'] ?? true;
      _profileImageUrl = profile['profile_image_url'];

      _dailyPracticeReminder = profile['daily_practice_reminder'] ?? true;
      _reminderTime = profile['reminder_time'] ?? '9:00 AM';
      _soundEffectsEnabled = profile['sound_effects_enabled'] ?? true;
      _volumeLevel = (profile['volume_level'] as num?)?.toDouble() ?? 0.8;
    }

    setState(() => _isLoading = false);
  }

  // ===================== IMAGE PICK + UPLOAD =====================
  Future<void> _pickAndUploadImage() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final filePath = '${user.id}/profile.jpg';

    try {
      await supabase.storage
          .from('avatars')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      // ✅ Get public URL + cache buster
      final rawUrl = supabase.storage.from('avatars').getPublicUrl(filePath);

      // 🔥 cache-busting
      final imageUrl = '$rawUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      await supabase
          .from('profiles')
          .update({'profile_image_url': imageUrl}).eq('id', user.id);

      setState(() {
        _profileImageUrl = imageUrl;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile image updated')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  Future<void> _removeProfileImage() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final filePath = '${user.id}/profile.jpg';

    try {
      // 1️⃣ Remove from storage
      await supabase.storage.from('avatars').remove([filePath]);

      // 2️⃣ Remove URL from profile
      await supabase
          .from('profiles')
          .update({'profile_image_url': null}).eq('id', user.id);

      // 3️⃣ Update UI immediately
      setState(() {
        _profileImageUrl = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile image removed')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to remove image: $e')));
    }
  }

  // ===================== SAVE PROFILE =====================
  Future<void> _saveProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final age = int.tryParse(_ageController.text.trim());
    if (_nameController.text.trim().isEmpty || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and age are required')),
      );
      return;
    }

    // Age group calculation
    String ageGroup;
    if (age < 18) {
      ageGroup = 'Under 18';
    } else if (age <= 24) {
      ageGroup = '18-24 years';
    } else if (age <= 34) {
      ageGroup = '25-34 years';
    } else if (age <= 44) {
      ageGroup = '35-44 years';
    } else if (age <= 54) {
      ageGroup = '45-54 years';
    } else if (age <= 64) {
      ageGroup = '55-64 years';
    } else if (age <= 74) {
      ageGroup = '65-74 years';
    } else {
      ageGroup = '75+ years';
    }

    setState(() => _isSaving = true);

    await supabase.from('profiles').update({
      'full_name': _nameController.text.trim(),
      'age': age,
      'age_group': ageGroup,
      'experience_level': _experienceLevel,
      'preferred_session_length': _sessionLength,
      'preferred_language': _language,
      'push_notifications_enabled': _pushNotifications,
      'daily_practice_reminder': _dailyPracticeReminder,
      'reminder_time': _reminderTime,
      'sound_effects_enabled': _soundEffectsEnabled,
      'volume_level': _volumeLevel,
    }).eq('id', user.id);

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    const turquoise = Color(0xFF40E0D0);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF6F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1F3D3A)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFF1F3D3A)),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF40E0D0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🖼️ PROFILE IMAGE — TOP
            _card(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor:
                          const Color(0xFF40E0D0).withOpacity(0.15),
                      backgroundImage: _profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : null,
                      child: _profileImageUrl == null
                          ? const Icon(Icons.camera_alt, size: 28)
                          : null,
                    ),
                  ),
                ),
                // 🔴 REMOVE IMAGE BUTTON (only show if image exists)
                if (_profileImageUrl != null) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: _removeProfileImage,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text(
                        'Remove photo',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // 👤 NAME & AGE
            _card(
              children: [
                _textField('Full Name', _nameController),
                _textField(
                  'Age',
                  _ageController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            _card(
              title: 'Preferences',
              children: [
                _dropdown(
                  'Experience Level',
                  _experienceLevel,
                  ['Beginner', 'Intermediate', 'Advanced'],
                  (v) => setState(() => _experienceLevel = v),
                ),
                _dropdown(
                  'Session Length',
                  _sessionLength,
                  [
                    '5 minutes',
                    '10 minutes',
                    '15 minutes',
                    '20 minutes',
                    '30 minutes',
                    '45 minutes',
                    '60 minutes',
                  ],
                  (v) => setState(() => _sessionLength = v),
                ),
                _dropdown(
                    'Language',
                    _language,
                    [
                      'English',
                      'Mandarin',
                    ],
                    (v) => setState(() => _language = v)),
              ],
            ),

            _card(
              title: 'Notifications',
              children: [
                SwitchListTile(
                    title: const Text('Push Notifications'),
                    value: _pushNotifications,
                    activeColor: turquoise,
                    onChanged: (v) {
                      setState(() => _pushNotifications = v);
                      // Trigger the local notification if turned on
                      if (v == true) {
                        NotificationService().showNotification(
                          title: 'HealYoga',
                          body: 'Push notifications enabled! 🔔',
                        );
                      }
                    }),
                SwitchListTile(
                    title: const Text('Daily Practice Reminder'),
                    value: _dailyPracticeReminder,
                    activeColor: turquoise,
                    onChanged: (v) {
                      setState(() => _dailyPracticeReminder = v);
                      // Trigger the local notification if turned on
                      if (v == true) {
                        NotificationService().showNotification(
                          title: 'Daily Reminder Enabled!',
                          body: 'We will remind you every day to practice. 🌞',
                        );
                      }
                    }),
                ListTile(
                  title: const Text('Reminder Time'),
                  trailing: Text(
                    _reminderTime,
                    style: const TextStyle(color: Color(0xFF6B8F8A)),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _reminderTime = time.format(context);
                      });

                      if (_dailyPracticeReminder == true) {
                        NotificationService().scheduleDailyNotification(
                          id: 101, // Unique ID for this daily reminder
                          title: 'Daily Practice Reminder',
                          body: 'Time for your daily session! 🏃‍♀️',
                          hour: time.hour,
                          minute: time.minute,
                        );

                        NotificationService().showNotification(
                          title: 'Reminder Time Set!',
                          body: 'We will remind you every day at $_reminderTime 🕓',
                        );
                      } else {
                        NotificationService().cancelNotification(101);
                      }
                    }
                  },
                ),
              ],
            ),

            _card(
              title: 'Sound',
              children: [
                SwitchListTile(
                  title: const Text('Sound Effects'),
                  value: _soundEffectsEnabled,
                  activeColor: turquoise,
                  onChanged: (v) => setState(() => _soundEffectsEnabled = v),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Volume',
                      style: TextStyle(color: Color(0xFF6B8F8A)),
                    ),
                    Slider(
                      value: _volumeLevel,
                      min: 0,
                      max: 1,
                      divisions: 10,
                      label: '${(_volumeLevel * 100).round()}%',
                      activeColor: turquoise,
                      onChanged: (v) => setState(() => _volumeLevel = v),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===================== HELPERS =====================
  Widget _card({String? title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E6F68),
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }
}
