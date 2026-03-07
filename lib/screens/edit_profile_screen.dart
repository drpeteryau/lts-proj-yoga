import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/notification_service.dart';
import '../services/global_audio_service.dart';
import 'package:volume_controller/volume_controller.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // volume_controller has no web implementation — skip all its calls on web
  static const bool _isWebPlatform = kIsWeb;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _initVolumeController();
  }

  // ===================== INIT VOLUME =====================
  Future<void> _initVolumeController() async {
    if (_isWebPlatform) return; // no native volume plugin on web
    final currentVolume = await VolumeController.instance.getVolume();
    setState(() {
      _volumeLevel = currentVolume;
      _previousVolume = currentVolume;
    });
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
      // Logic to handle old data
      if (_language == 'Mandarin') {
        _language = 'Mandarin (Simplified)'; // Map old value to new default
      } else {
        _language = _language;
      }
      // Update the locale based on the corrected _language
      if (_language == 'Mandarin (Simplified)') {
        appLocale.value = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
      } else if (_language == 'Mandarin (Traditional)') {
        appLocale.value = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
      } else {
        appLocale.value = const Locale('en');
      }

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

      // Set system volume to saved preference (native only)
      if (!_isWebPlatform) {
        await VolumeController.instance.setVolume(savedVolume);
      }
      // Apply to app audio player on all platforms
      await GlobalAudioService().setVolume(savedVolume);
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

    final filePath = '${user.id}/profile.jpg';

    try {
      if (_isWebPlatform) {
        // Web: dart:io File doesn't exist — read as bytes directly
        final bytes = await pickedFile.readAsBytes();
        await supabase.storage
            .from('avatars')
            .uploadBinary(filePath, bytes, fileOptions: const FileOptions(upsert: true));
      } else {
        // Native: use File as before
        final file = File(pickedFile.path);
        await supabase.storage
            .from('avatars')
            .upload(filePath, file, fileOptions: const FileOptions(upsert: true));
      }

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
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.photoUpdated)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.photoFail}: $e')));
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
        SnackBar(content: Text(AppLocalizations.of(context)!.validationError)),
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
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFD4F1F0),
                Color(0xFFFFFFFF),
                Color(0xFFE8F9F3),
                Color(0xFFFFE9DB),
              ],
              stops: [0.0, 0.3, 0.6, 1.0],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: turquoise),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4F1F0),
              Color(0xFFFFFFFF),
              Color(0xFFE8F9F3),
              Color(0xFFFFE9DB),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom header
              Padding(
                padding: EdgeInsets.all(isWeb ? 24 : 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.editProfile,
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 32 : 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isSaving ? null : () async {
                        GlobalAudioService.playClickSound();
                        _saveProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: turquoise,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 28 : 24,
                          vertical: isWeb ? 14 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 16 : 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 28 : 20),
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
                                    PopupMenuItem(
                                      value: 'upload',
                                      child: Row(
                                        children: [
                                          Icon(Icons.upload, color: Color(0xFF2E6F68)),
                                          SizedBox(width: 8),
                                          Text(AppLocalizations.of(context)!.uploadPhoto),
                                        ],
                                      ),
                                    ),
                                    if (_profileImageUrl != null)
                                      PopupMenuItem(
                                        value: 'remove',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text(AppLocalizations.of(context)!.removePhoto),
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
                          title: AppLocalizations.of(context)!.basicInfo,
                          children: [
                            _textField(AppLocalizations.of(context)!.fullName, _nameController),
                            _textField(AppLocalizations.of(context)!.age, _ageController,
                                keyboardType: TextInputType.number),
                            // _dropdown(AppLocalizations.of(context)!.experienceLevel, _experienceLevel,
                            //     ['Beginner', 'Intermediate', 'Advanced'],
                            //         (v) => setState(() => _experienceLevel = v)),
                            _dropdown(
                                AppLocalizations.of(context)!.sessionLength,
                                _sessionLength,
                                [
                                  '5 minutes',
                                  '10 minutes',
                                  '15 minutes',
                                  '20 minutes',
                                  '30 minutes'
                                ],
                                    (v) => setState(() => _sessionLength = v),
                                itemLabelBuilder: (value) {
                                  if (value == '5 minutes') return AppLocalizations.of(context)!.min5;
                                  if (value == '10 minutes') return AppLocalizations.of(context)!.min10;
                                  if (value == '15 minutes') return AppLocalizations.of(context)!.min15;
                                  if (value == '20 minutes') return AppLocalizations.of(context)!.min20;
                                  if (value == '30 minutes') return AppLocalizations.of(context)!.min30;
                                  return value;
                                }),
                            _dropdown(
                              AppLocalizations.of(context)!.language,
                              _language,
                              [
                                'English',
                                'Mandarin (Simplified)',
                                'Mandarin (Traditional)',
                              ],
                              (v) {
                                setState(() => _language = v);
                                if (v == 'Mandarin (Simplified)') {
                                  appLocale.value = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
                                } else if (v == 'Mandarin (Traditional)') {
                                  appLocale.value = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
                                } else {
                                  appLocale.value = const Locale('en');
                                }
                              },
                              itemLabelBuilder: (value) {
                                if (value == 'English') return AppLocalizations.of(context)!.english;
                                if (value == 'Mandarin (Simplified)') return AppLocalizations.of(context)!.mandarinSimplified;
                                if (value == 'Mandarin (Traditional)') return AppLocalizations.of(context)!.mandarinTraditional;
                                  return value;
                              },                
                            ),
                          ],
                        ),

                        _card(
                          title: AppLocalizations.of(context)!.notifications,
                          children: [
                            SwitchListTile(
                                title: Text(AppLocalizations.of(context)!.pushNotifications),
                                value: _pushNotifications,
                                activeThumbColor: turquoise,
                                onChanged: (v) {
                                  GlobalAudioService.playClickSound();
                                  setState(() => _pushNotifications = v);
                                  // Trigger the local notification if turned on
                                  if (v == true) {
                                    NotificationService().showNotification(
                                      title: 'HealYoga',
                                      body: AppLocalizations.of(context)!.pushEnabledMsg,
                                    );
                                  }
                                }),
                            SwitchListTile(
                                title: Text(AppLocalizations.of(context)!.dailyReminder),
                                value: _dailyPracticeReminder,
                                activeThumbColor: turquoise,
                                onChanged: (v) {
                                  GlobalAudioService.playClickSound();
                                  setState(() => _dailyPracticeReminder = v);
                                  // Trigger the local notification if turned on
                                  if (v == true) {
                                    NotificationService().showNotification(
                                      title: AppLocalizations.of(context)!.dailyReminderEnabled,
                                      body: '${AppLocalizations.of(context)!.dailyEnabledMsg} $_reminderTime',
                                    );
                                  }
                                }),
                            ListTile(
                              title: Text(AppLocalizations.of(context)!.reminderTime),
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
                                      title: AppLocalizations.of(context)!.dailyReminderNotification,
                                      body: AppLocalizations.of(context)!.dailyReminderBody,
                                      hour: time.hour,
                                      minute: time.minute,
                                    );

                                    // NotificationService().showNotification(
                                    //   title: 'Reminder Time Set!',
                                    //   body:
                                    //   'We will remind you every day at $_reminderTime 🕓',
                                    // );
                                  } else {
                                    NotificationService().cancelNotification(101);
                                  }
                                }
                              },
                            ),
                          ],
                        ),

                        _card(
                          title: AppLocalizations.of(context)!.sound,
                          children: [
                            SwitchListTile(
                                title: Text(AppLocalizations.of(context)!.soundEffects),
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
                                      Text(
                                        _isWebPlatform ? AppLocalizations.of(context)!.appVolume : AppLocalizations.of(context)!.systemVolume,
                                        style: const TextStyle(
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
                                          if (!_isWebPlatform) {
                                            await VolumeController.instance.setVolume(_volumeLevel);
                                          }
                                          await GlobalAudioService().setVolume(_volumeLevel);
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
                                            if (!_isWebPlatform) {
                                              await VolumeController.instance.setVolume(v);
                                            }
                                            await GlobalAudioService().setVolume(v);
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
                                          if (!_isWebPlatform) {
                                            await VolumeController.instance.setVolume(1.0);
                                          }
                                          await GlobalAudioService().setVolume(1.0);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _isWebPlatform
                                        ? AppLocalizations.of(context)!.appVolumeDesc
                                        : AppLocalizations.of(context)!.systemVolumeDesc,
                                    style: const TextStyle(
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
                      ]),                
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== HELPERS =====================
  Widget _card({String? title, required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.only(bottom: isWeb ? 20 : 16),
      padding: EdgeInsets.all(isWeb ? 28 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 22 : 20,
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
      padding: EdgeInsets.only(bottom: isWeb ? 18 : 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          fontSize: isWeb ? 17 : 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: isWeb ? 16 : 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF40E0D0), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isWeb ? 20 : 16,
            vertical: isWeb ? 18 : 16,
          ),
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
      ValueChanged<String> onChanged, {
        String Function(String)? itemLabelBuilder,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isWeb ? 18 : 16),
      child: DropdownButtonFormField<String>(
          initialValue: value,
          style: GoogleFonts.poppins(
            fontSize: isWeb ? 17 : 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontSize: isWeb ? 16 : 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF40E0D0), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isWeb ? 20 : 16,
              vertical: isWeb ? 18 : 16,
            ),
          ),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(itemLabelBuilder != null ? itemLabelBuilder(e) : e),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) {
              GlobalAudioService.playClickSound();
              onChanged(v);
            }
          }
      ),
    );
  }
}