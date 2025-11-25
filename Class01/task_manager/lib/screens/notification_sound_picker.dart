import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

// IMPORTANT: Yeh sirf placeholder sounds hain.
// In sound files ko aapko apne Flutter project ke 'assets/sounds/' folder mein add karna hoga.
const Map<String, String> availableSounds = {
  'Default System Sound': 'default',
  'Alert Chime': 'chime.mp3',
  'Bell Ring': 'bell.mp3',
  'Magic Wand': 'magic_wand.mp3',
  'Echo Pulse': 'echo_pulse.mp3',
};

class NotificationSoundPicker extends StatefulWidget {
  // ✅ FIX 1: Constructor mein initialSound receive karein
  final String initialSound;
  const NotificationSoundPicker({super.key, required this.initialSound});

  @override
  State<NotificationSoundPicker> createState() =>
      _NotificationSoundPickerState();
}

class _NotificationSoundPickerState extends State<NotificationSoundPicker> {
  // ✅ FIX 2: soundPath ki bajaye soundName store karein (joh TaskEditSheet use karta hai)
  String? _selectedSoundValue;

  // SharedPreferences mein sound path save karne ke liye key (Local App settings ke liye)
  // NOTE: Hum TaskEditSheet ke through Task object mein sound name save kar rahe hain.
  // Isliye hum yahan SharedPrefs ki zaroorat nahi hai, sirf local state update karenge.

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // ✅ FIX 3: Initial sound name ko constructor se load karein
    _selectedSoundValue = widget.initialSound;
    
    // Set AudioPlayer mode for better performance
    _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  // NEW: Clean up AudioPlayer
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- Helper to map Sound Name to Sound Path (e.g., 'Alert Chime' -> 'chime.mp3') ---
  String _getSoundPathFromName(String name) {
    // Agar name 'Default System Sound' hai, to path 'default' milega
    return availableSounds[name] ?? 'default';
  }

  // --- UPDATED: Sound ko preview (bajaane) ke liye functional logic ---
  void _previewSound(String soundPath) async {
    try {
      // Stop any currently playing sound
      await _audioPlayer.stop();
      
      if (soundPath == 'default') {
        _showInfoSnackbar(
          context,
          'Using system default sound. Cannot preview asset.',
        );
        return;
      }

      // Play the audio file from assets/sounds/
      // soundPath already contains the filename (e.g., 'chime.mp3')
      await _audioPlayer.play(
        AssetSource('sounds/$soundPath'),
        volume: 0.7,
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      // Show detailed error if playing fails
      _showInfoSnackbar(
        context,
        'Error playing sound: $e',
        success: false,
      );
      print('Sound playback error: $e');
    }
  }
  // ------------------------------------------------------------------

  // --- NEW: Handle selection and return to previous screen ---
  void _handleSelection(String soundName) async {
    setState(() {
      _selectedSoundValue = availableSounds[soundName] ?? 'default';
    });

    final soundPath = _getSoundPathFromName(soundName);

    // Preview sound jab set ho jaye
    _previewSound(soundPath);

    // Save to SharedPreferences for settings screen
    await _saveSoundPreference(soundName);

    // Return selected sound name to settings screen after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context, soundName);
      }
    });
  }

  // Save selected sound to SharedPreferences
  Future<void> _saveSoundPreference(String soundName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Save to both keys for compatibility
      await prefs.setString('selectedNotificationSound', soundName);
      await prefs.setString('notification_sound', soundName);
    } catch (e) {
      print('Error saving sound preference: $e');
    }
  }
  // ---------------------------------------------------------

  void _showInfoSnackbar(
    BuildContext context,
    String message, {
    bool success = false,
  }) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    final error = theme.colorScheme.error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? accent : error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check agar list abhi tak load nahi hui hai
    if (_selectedSoundValue == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Choose Notification Sound',
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: availableSounds.length,
        itemBuilder: (context, index) {
          final entry = availableSounds.entries.elementAt(index);
          final soundName = entry.key;
          final soundPath = entry.value; // Yeh sirf preview ke liye use hoga

          final isSelected =
              _selectedSoundValue == soundPath; // ✅ FIX: value based check

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: Icon(
                Icons.volume_up,
                color: theme.colorScheme.secondary,
              ),
              title: Text(
                soundName,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Play/Preview Button
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () => _previewSound(
                      soundPath,
                    ), // Path use kiya preview ke liye
                  ),
                  // Selection Checkmark
                  if (isSelected)
                    Icon(Icons.check_circle, color: theme.colorScheme.secondary)
                  else
                    Icon(
                      Icons.circle_outlined,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                ],
              ),
              tileColor: isSelected
                  ? theme.colorScheme.secondary.withOpacity(0.1)
                  : theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.secondary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              onTap: () => _handleSelection(soundName),
            ),
          );
        },
      ),
    );
  }
}
