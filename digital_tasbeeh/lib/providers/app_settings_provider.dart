import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppSettingsProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  
  bool _vibration = true;
  bool _mute = false;
  String _language = 'eng';
  String _theme = 'dark';
  
  bool _isLoaded = false;

  bool get vibration => _vibration;
  bool get mute => _mute;
  String get language => _language;
  String get theme => _theme;
  bool get isLoaded => _isLoaded;

  AppSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _storage.loadSettings();
    _vibration = settings['vibration'] ?? true;
    _mute = settings['mute'] ?? false;
    _language = settings['language'] ?? 'eng';
    _theme = settings['theme'] ?? 'dark';
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await _storage.saveSettings({
      'vibration': _vibration,
      'mute': _mute,
      'language': _language,
      'theme': _theme,
    });
  }

  Future<void> setVibration(bool value) async {
    if (_vibration != value) {
      _vibration = value;
      notifyListeners();
      await _saveSettings();
    }
  }

  Future<void> setMute(bool value) async {
    if (_mute != value) {
      _mute = value;
      notifyListeners();
      await _saveSettings();
    }
  }

  Future<void> setLanguage(String value) async {
    if (_language != value) {
      _language = value;
      notifyListeners();
      await _saveSettings();
    }
  }

  Future<void> setTheme(String value) async {
    if (_theme != value) {
      _theme = value;
      notifyListeners();
      await _saveSettings();
    }
  }
}
