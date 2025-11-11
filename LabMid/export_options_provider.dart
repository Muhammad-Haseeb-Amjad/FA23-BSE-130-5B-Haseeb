import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/export_options.dart';

class ExportOptionsProvider with ChangeNotifier {
  // --- Constants for SharedPreferences Keys ---
  static const String _formatKey = 'export_format';
  static const String _fieldsKey = 'export_selected_fields';

  // --- State Variable ---
  ExportOptions _options = ExportOptions();

  ExportOptions get options => _options;

  ExportOptionsProvider() {
    _loadOptions();
  }

  // --- Persistence: Load Options ---
  Future<void> _loadOptions() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Load Format ('CSV' or 'PDF')
    final savedFormat = prefs.getString(_formatKey) ?? 'CSV';

    // 2. Load Selected Fields (List<String> ko List<String> ke roop mein save kiya jata hai)
    // Agar koi saved list na mile toh model ki default list use karein.
    final savedFields = prefs.getStringList(_fieldsKey) ?? _options.selectedFields;

    _options = ExportOptions(
      format: savedFormat,
      selectedFields: savedFields,
    );
    notifyListeners();
  }

  // --- Setter: Set Export Format ('CSV' or 'PDF') ---
  Future<void> setFormat(String newFormat) async {
    if (newFormat != _options.format) {
      _options.format = newFormat;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_formatKey, newFormat);

      notifyListeners();
    }
  }

  // --- Setter: Update Selected Fields (The new field list) ---
  Future<void> updateSelectedFields(List<String> newFields) async {
    // Check karein ki list change hui hai ya nahi (performance ke liye)
    if (_options.selectedFields.toString() != newFields.toString()) {
      _options.selectedFields = newFields;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_fieldsKey, newFields);

      notifyListeners();
    }
  }

  // --- Toggle Helper: Ek field ko add/remove karne ke liye ---
  void toggleField(String fieldName) {
    List<String> currentFields = List.from(_options.selectedFields);

    if (currentFields.contains(fieldName)) {
      // Agar field maujood hai, toh usay hata dein
      currentFields.remove(fieldName);
    } else {
      // Agar field maujood nahi hai, toh usay add karein
      currentFields.add(fieldName);
    }

    // Nayi list ko save karein
    updateSelectedFields(currentFields);
  }
}