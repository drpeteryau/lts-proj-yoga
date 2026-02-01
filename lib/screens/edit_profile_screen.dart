import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/notification_service.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/global_audio_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final supabase = Supabase.instance.client;

  // Responsive helper
  bool get isWeb => MediaQuery.of(context).size.width > 600;

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
  double _previousVolume = 0.8; // Track previous volume for mute/unmute

  bool _isLoading = true;
  bool _isSaving = false;

  // Audio player for feedback
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _initVolumeController();
  }

  // ===================== INIT VOLUME =====================
  Future<void> _initVolumeController() async {
    // Get current system volume
    final currentVolume = await VolumeController.instance.getVolume();
    setState(() {
      _volumeLevel = currentVolume;
      _previousVolume = currentVolume;
    });
  }

  // ===================== PLAY FEEDBACK SOUND =====================
  Future<void> _playVolumeTestSound() async {
    if (!_soundEffectsEnabled) return;

    // Play a short beep sound at the current volume level
    // You can replace this with your own sound file
    await _audioPlayer.setVolume(_volumeLevel);
    await _audioPlayer.play(AssetSource('sounds/chime.mp3')); // Make sure you have this asset
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

      final savedVolume = (profile['volume_level'] as num?)?.toDouble() ?? 0.8;
      setState(() {
        _volumeLevel = savedVolume;
        _previousVolume = savedVolume;
      });

      // Set system volume to saved preference
      await VolumeController.instance.setVolume(savedVolume);
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
    _audioPlayer.dispose();
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
            onPressed: _isSaving ? null : () async {
              GlobalAudioService.playClickSound();
              _saveProfile();
            },
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
        padding: EdgeInsets.all(isWeb ? 28 : 16),
        child: Column(
          children: [
            // ===================== PROFILE IMAGE =====================
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: turquoise.withOpacity(0.2),
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: _profileImageUrl == null
                        ? const Icon(Icons.person, size: 60, color: turquoise)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: turquoise,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                      onSelected: (value) {
                        if (value == 'upload') {
                          _pickAndUploadImage();
                        } else if (value == 'remove') {
                          _removeProfileImage();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'upload',
                          child: Row(
                            children: [
                              Icon(Icons.upload, color: Color(0xFF2E6F68)),
                              SizedBox(width: 8),
                              Text('Upload Photo'),
                            ],
                          ),
                        ),
                        if (_profileImageUrl != null)
                          const PopupMenuItem(
                            value: 'remove',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Remove Photo'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===================== BASIC INFO =====================
            _card(
              title: 'Basic Information',
              children: [
                _textField('Full Name', _nameController),
                _textField('Age', _ageController,
                    keyboardType: TextInputType.number),
                _dropdown('Experience Level', _experienceLevel,
                    ['Beginner', 'Intermediate', 'Advanced'],
                        (v) => setState(() => _experienceLevel = v)),
                _dropdown(
                    'Session Length',
                    _sessionLength,
                    [
                      '15 minutes',
                      '20 minutes',
                      '30 minutes',
                      '45 minutes',
                      '60 minutes',
                    ],
                        (v) => setState(() => _sessionLength = v)),
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
                    activeThumbColor: turquoise,
                    onChanged: (v) {
                      GlobalAudioService.playClickSound();
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
                    activeThumbColor: turquoise,
                    onChanged: (v) {
                      GlobalAudioService.playClickSound();
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
                    GlobalAudioService.playClickSound();
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
                          body:
                          'We will remind you every day at $_reminderTime 🕓',
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
                  activeThumbColor: turquoise,
                  onChanged: (v) {
                    setState(() => _soundEffectsEnabled = v);
                    GlobalAudioService.isSoundEffectsEnabled = v;
                    if (v) {
                      GlobalAudioService.playClickSound();
                    }
                  }
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'System Volume',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2E6F68),
                            ),
                          ),
                          Text(
                            '${(_volumeLevel * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B8F8A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // --- Mute Button ---
                          IconButton(
                            icon: Icon(
                              _volumeLevel == 0
                                  ? Icons.volume_off
                                  : Icons.volume_mute,
                              color: const Color(0xFF6B8F8A),
                            ),
                            onPressed: () async {
                              setState(() {
                                if (_volumeLevel > 0) {
                                  _previousVolume = _volumeLevel;
                                  _volumeLevel = 0;
                                } else {
                                  _volumeLevel = _previousVolume;
                                }
                              });
                              await VolumeController.instance.setVolume(_volumeLevel);
                              _playVolumeTestSound();
                            },
                          ),

                          // --- The Slider ---
                          Expanded(
                            child: Slider(
                              value: _volumeLevel,
                              min: 0,
                              max: 1,
                              divisions: 10,
                              label: '${(_volumeLevel * 100).round()}%',
                              activeColor: turquoise,
                              onChanged: (v) async {
                                setState(() => _volumeLevel = v);
                                await VolumeController.instance.setVolume(v);
                              },
                              onChangeEnd: (v) {
                                // Play feedback when user releases slider
                                _playVolumeTestSound();
                              },
                            ),
                          ),

                          // --- Max Button ---
                          IconButton(
                            icon: const Icon(Icons.volume_up,
                                color: Color(0xFF6B8F8A)),
                            onPressed: () async {
                              setState(() {
                                _volumeLevel = 1.0;
                              });
                              await VolumeController.instance.setVolume(1.0);
                              _playVolumeTestSound();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Adjusts your device system volume',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
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
      padding: EdgeInsets.all(isWeb ? 28 : 16),
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
        onTap: () {
          GlobalAudioService.playClickSound();          
        },
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
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) {
        GlobalAudioService.playClickSound();
        onChanged(v!);
      }
      ),
    );
  }
}