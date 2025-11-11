import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme.dart';

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
  State<NotificationSoundPicker> createState() => _NotificationSoundPickerState();
}

class _NotificationSoundPickerState extends State<NotificationSoundPicker> {
  // ✅ FIX 2: soundPath ki bajaye soundName store karein (joh TaskEditSheet use karta hai)
  String? _selectedSoundName;

  // SharedPreferences mein sound path save karne ke liye key (Local App settings ke liye)
  // NOTE: Hum TaskEditSheet ke through Task object mein sound name save kar rahe hain.
  // Isliye hum yahan SharedPrefs ki zaroorat nahi hai, sirf local state update karenge.

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // ✅ FIX 3: Initial sound name ko constructor se load karein
    _selectedSoundName = widget.initialSound;
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
    await _audioPlayer.stop();

    if (soundPath == 'default') {
      _showInfoSnackbar(context, 'Using system default sound. Cannot preview asset.');
      return;
    }

    // Play the audio file from assets/sounds/
    try {
      await _audioPlayer.play(
        AssetSource('sounds/$soundPath'),
        volume: 0.5,
      );
    } catch (e) {
      // Show detailed error if playing fails
      _showInfoSnackbar(context, 'Error playing sound. Check asset path or package configuration: $e', success: false);
    }
  }
  // ------------------------------------------------------------------

  // --- NEW: Handle selection and return to previous screen ---
  void _handleSelection(String soundName) {
    setState(() {
      _selectedSoundName = soundName;
    });

    final soundPath = _getSoundPathFromName(soundName);

    // Preview sound jab set ho jaye
    _previewSound(soundPath);

    // ✅ FIX 4: Navigator ko call karein taake selected sound name TaskEditSheet ko wapas mil jaye
    // NOTE: Ab hum SharedPrefs mein save nahi kar rahe, sirf TaskEditSheet ko value return kar rahe hain.
    Navigator.pop(context, soundName);
  }
  // ---------------------------------------------------------

  void _showInfoSnackbar(BuildContext context, String message, {bool success = false}) {
    final Color accentGreen = Theme.of(context).colorScheme.secondary;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? accentGreen : Colors.grey,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check agar list abhi tak load nahi hui hai
    if (_selectedSoundName == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Choose Notification Sound', style: TextStyle(color: theme.colorScheme.onBackground)),
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

          final isSelected = _selectedSoundName == soundName; // ✅ FIX: Ab name se compare karein

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: Icon(Icons.volume_up, color: theme.colorScheme.secondary),
              title: Text(soundName, style: TextStyle(color: theme.colorScheme.onSurface)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Play/Preview Button
                  IconButton(
                    icon: Icon(Icons.play_arrow, color: theme.colorScheme.primary),
                    onPressed: () => _previewSound(soundPath), // Path use kiya preview ke liye
                  ),
                  // Selection Checkmark
                  if (isSelected)
                    Icon(Icons.check_circle, color: theme.colorScheme.secondary)
                  else
                    Icon(Icons.circle_outlined, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ],
              ),
              tileColor: isSelected ? theme.colorScheme.secondary.withOpacity(0.1) : theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
                      width: 1.5
                  )
              ),
              onTap: () => _handleSelection(soundName), // ✅ FIX: Handle selection and return
            ),
          );
        },
      ),
    );
  }
}